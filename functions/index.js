const functions = require("firebase-functions");
const { stripeSecretKey } = require("./stripe-config");

const admin = require("firebase-admin");

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

        await admin.
            firestore()
            .collection("customers")
            .doc(user.uid).set({
                setup: false,
                stripeCustomerId: customer.id,
                createdAt: customer.created,
                email: customer.email,
                invoicePrefix: customer.invoicePrefix,
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
        const fullname = `${firstname} ${middlename} ${lastname}`;

        const { line1, line2, city, state, postalCode, country } = newValue.address;

        await stripe.customers.update(stripeCustomerId,
            {
                name: fullname,
                phone: phone,
                address: { line1, line2, city, state, postal_code: postalCode, country },
            },
        );
    });

