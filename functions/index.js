/**
 * Reset de senha apenas com matrícula (sem email / sem prova de posse).
 * Modo inicial pedido pelo produto — qualquer um que saiba a matrícula pode redefinir.
 * Para endurecer depois: exigir App Check, rate limit, ou reset só por admin.
 */
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

function emailFromMatricula(matricula) {
  const clean = String(matricula).replace(/[^a-zA-Z0-9._-]/g, "");
  if (!clean) return "";
  return `${clean.toLowerCase()}@ponto.app`;
}

exports.resetPasswordByMatricula = onCall({ region: "us-central1" }, async (request) => {
    const matricula = (request.data?.matricula ?? "").toString().trim();
    const newPassword = (request.data?.newPassword ?? "").toString();

    if (!matricula) {
      throw new HttpsError("invalid-argument", "Informe a matrícula.");
    }
    if (newPassword.length < 6) {
      throw new HttpsError(
        "invalid-argument",
        "A senha deve ter no mínimo 6 caracteres."
      );
    }

    const email = emailFromMatricula(matricula);
    if (!email || !email.includes("@")) {
      throw new HttpsError("invalid-argument", "Matrícula inválida.");
    }

    try {
      const user = await admin.auth().getUserByEmail(email);
      await admin.auth().updateUser(user.uid, { password: newPassword });
      return { ok: true };
    } catch (e) {
      if (e.code === "auth/user-not-found") {
        throw new HttpsError(
          "not-found",
          "Não existe conta para esta matrícula. Faça o primeiro login com a senha inicial."
        );
      }
      if (e.code === "auth/invalid-password") {
        throw new HttpsError(
          "invalid-argument",
          "Senha inválida para o Firebase (tente outra combinação)."
        );
      }
      console.error(e);
      throw new HttpsError(
        "internal",
        e.message || "Falha ao alterar a senha. Tente novamente."
      );
    }
});
