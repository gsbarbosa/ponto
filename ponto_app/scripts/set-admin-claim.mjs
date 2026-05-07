import fs from 'node:fs';
import process from 'node:process';
import admin from 'firebase-admin';

function readServiceAccountFromEnv() {
  const encoded = process.env.FIREBASE_KEY;
  if (!encoded) {
    throw new Error('FIREBASE_KEY não definido no ambiente.');
  }
  const decoded = Buffer.from(encoded, 'base64').toString('utf-8');
  return JSON.parse(decoded);
}

async function main() {
  const email = process.argv[2];
  if (!email) {
    throw new Error('Uso: npm run admin:set-claim -- <email-do-admin>');
  }

  const serviceAccount = readServiceAccountFromEnv();
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }

  const user = await admin.auth().getUserByEmail(email);
  await admin.auth().setCustomUserClaims(user.uid, { admin: true });

  const out = {
    email,
    uid: user.uid,
    claims: { admin: true },
  };
  fs.writeFileSync('admin-claim-result.json', JSON.stringify(out, null, 2));
  console.log(`Claim admin=true aplicado para ${email} (${user.uid})`);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
