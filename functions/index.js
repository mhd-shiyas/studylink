const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyTeacherApproval = functions.firestore
    .document("teachers/{teacherId}")
    .onUpdate(async (change, context) => {
        const beforeStatus = change.before.data().status;
        const afterStatus = change.after.data().status;
        const teacherId = context.params.teacherId;

        if (beforeStatus !== "Approved" && afterStatus === "Approved") {
            const teacherDoc = await admin.firestore().collection("teachers").doc(teacherId).get();
            const teacherToken = teacherDoc.data().fcmToken; // Fetch FCM token

            if (!teacherToken) {
                console.log("❌ No FCM token found for teacher:", teacherId);
                return;
            }

            const payload = {
                notification: {
                    title: "Approval Accepted 🎉",
                    body: "Your teacher account has been approved! You can now log in.",
                    sound: "default",
                },
                token: teacherToken,
            };

            await admin.messaging().send(payload);
            console.log("✅ Approval notification sent to teacher:", teacherId);
        }
    });
