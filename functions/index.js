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

    exports.onTradeAlertWrite = functions.firestore.document("tradeAlerts/{alertId}")
    .onWrite(async (snapshot, context) => {  
        const data = snapshot.after.data();  

        const querySnapshot = await admin.firestore().collection("subscriptions").get(); 
        const docs = querySnapshot.docs.filter((doc) => doc.data().status === "active");

        for (const doc of docs) {
            const token = doc.data().optionAlertToken;    
            const title = 'Trade Alert | OXT';
            const options = { priority: "high" }; 

            const payload = {
                notification: {
                    title: title,
                    body: data.description,
                },
                data: {
                    data: JSON.stringify(data),
                },
            };
            await admin.messaging().sendToDevice(token, payload, options).then((response) => {
                functions.logger.log(response);
            }).catch((error) => {
                functions.logger.error(error);
            });  
        }
    });


    exports.onInsightAlertWrite = functions.firestore.document("insights/{insightId}")
    .onWrite(async (snapshot, context) => {  
        const data = snapshot.after.data();  

        const querySnapshot = await admin.firestore().collection("subscriptions").get(); 
        const docs = querySnapshot.docs.filter((doc) => doc.data().status === "active");

        for (const doc of docs) {
            const token = doc.data().optionAlertToken;   
            let title = 'Weekly Trading Insight | OXT';

            const options = { priority: "high" };

            if(data.type === "daily") {
                title = 'Daily Trading Insight | OXT'; 
            }   
            const payload = {
                notification: {
                    title: title,
                    body: data.description,
                },
                data: {
                    data: JSON.stringify(data),
                },
            };
            await admin.messaging().sendToDevice(token, payload, options).then((response) => {
                functions.logger.log(response);
            }).catch((error) => {
                functions.logger.error(error);
            });  
        }
    });

