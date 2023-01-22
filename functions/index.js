const functions = require("firebase-functions");
const { stripeSecretKey } = require("./stripe-config");

const admin = require("firebase-admin");
const serviceAccount = require("./google_service.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const stripe = require("stripe")(stripeSecretKey);

exports.createUserInStripe = functions
    .auth
    .user()
    .onCreate(async (user) => {
        const customer = await stripe.customers.create({
            email: user.email,
            metadata: {
                firebaseUid: user.uid,
            },
        });

        

        const createdAt = admin.firestore.Timestamp.fromMillis(customer.created * 1000);
        await admin.
            firestore()
            .collection("customers")
            .doc(user.uid).set({
                setup: false,
                stripeCustomerId: customer.id,
                createdAt: createdAt, 
                email: customer.email,
                invoicePrefix: customer.invoice_prefix,
                firebaseUid: customer.metadata.firebaseUid,
            });
    });

exports.onUpdateCustomer = functions
    .firestore
    .document('customers/{firebaseUid}')
    .onUpdate(async (change, context) => {
        const newValue = change.after.data();
        const oldValue = change.before.data();

        const stripeCustomerId = oldValue.stripeCustomerId;

        const { firstname, middlename, lastname, phone } = newValue;

        const fullname = middlename == "" ? `${firstname} ${lastname}` : `${firstname} ${middlename} ${lastname}`;

        const { line1, line2, city, state, zipcode } = newValue.address;

        await stripe.customers.update(stripeCustomerId,
            {
                name: fullname,
                phone: phone,
                address: { line1, line2, city, state, postal_code: zipcode, country: "US" },
            },
        );
    });


