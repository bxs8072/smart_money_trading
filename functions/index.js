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

exports.onAlertCreate = functions.firestore.document("optionAlerts/{uid}/optionAlerts/{alertId}")
.onCreate(async (snapshot, context) => {
    
    const uid = context.params.uid; 
    const data = snapshot.data(); 
    
    console.log(data);

    functions.logger.log(`Sending Notification About New Alert`);

    const customer = await admin.firestore().collection("customers").doc(uid).get();
    const token = customer.data().optionAlertToken;

    const prices = data.prices;

    strikePriceMessage = "";

    if(prices.length == 1) {
        strikePriceMessage = "Strike Price: $" + prices[0];
    }

    if(prices.length == 2) { 
        strikePriceMessage = "Strike Price 1: $" + prices[0] + ", Strike Price 2: $" + prices[1];
    }

    if(prices.length == 4) { 
        strikePriceMessage = "Strike Price 1: $" + prices[0] + ", Strike Price 2: $" + prices[1] + ", Strike Price 3: $" + prices[2] + ", Strike Price 4: $" + prices[3];
    }

    const payload = {
        notification: {
            title: "Option Alert",
            body: `Stock Ticker: ${data.ticker.title}, Total Cost: ${data.totalCost}, Strategy: ${data.strategy}, ${strikePriceMessage}, ${data.description}`,
        },
        data: {
            data: JSON.stringify(data),
        }, 
    };

    const options = { priority: "high" };
    await admin.messaging().sendToDevice(token, payload, options).then((response) => {
        functions.logger.log(response);
    }).catch((error) => {
        functions.logger.error(error);
    });
});

