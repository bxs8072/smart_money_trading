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

    functions.logger.log(`Sending Notification About New Alert`);

    const customer = await admin.firestore().collection("customers").doc(uid).get();
    const token = customer.data().optionAlertToken;

    const payload = {
        notification: {
            title: "Option Alert",
            body: `Stock Ticker: ${data.ticker.title}, Strategy: ${data.strategy}, Strike Price: ${data.price}, ${data.description}`,
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

// async function test()  {
//     console.log(`Sending Notification About New Alert`);

//     const customer = await admin.firestore().collection("customers").doc("d3oPcGm74ReKYjW4QqgTJiMe4WO2").get();
//     const token = customer.data().optionAlertToken;

//     const data = {
//         ticker: {
//             title: "aapl",
//         },
//         strategy: "CALL",
//         price: 150,
//         description: "This is a description",
//         createdAt: admin.firestore.Timestamp.now(),
//     };

//     const payload = {
//         notification: {
//             title: "Option Alert",
//             body: `Stock Ticker: ${data.ticker.title}, Strategy: ${data.strategy}, Strike Price: ${data.price}, ${data.description}`,
//         },
//         data: {
//             data: JSON.stringify(data),
//         }, 
//     };

//     const options = { priority: "high" };
//     await admin.messaging().sendToDevice(token, payload, options).then((response) => {
//         console.log(response);
//     }).catch((error) => {
//         console.error(error);
//     });
// }

// test()