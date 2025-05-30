const admin = require("firebase-admin");
const serviceAccount = require("./trombol-db-firebase-adminsdk-fbsvc-4ebea014b9.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

/**
 * Links a list of keyword IDs to a given product.
 * Updates both product and keyword documents bi-directionally.
 * Enforces a maximum of 5 keywords per product.
 */
async function linkKeywordsToProduct(productId, keywordIds) {
  if (keywordIds.length > 5) {
    throw new Error("❌ A product can have a maximum of 5 keywords.");
  }

  const productRef = db.collection("products").doc(productId);
  const productDoc = await productRef.get();

  if (!productDoc.exists) {
    throw new Error(`❌ Product with ID "${productId}" not found.`);
  }

  const batch = db.batch();

  // Step 1: Update the product's keyword_ids field
  batch.update(productRef, {
    keyword_ids: keywordIds
  });

  // Step 2: Update each keyword document's related_product_ids field
  for (const keywordId of keywordIds) {
    const keywordRef = db.collection("Keyword").doc(keywordId);
    const keywordDoc = await keywordRef.get();

    if (!keywordDoc.exists) {
      console.warn(`⚠️ Keyword with ID "${keywordId}" not found. Skipping.`);
      continue;
    }

    const existingRelated = keywordDoc.data().related_product_ids || [];

    if (!existingRelated.includes(productId)) {
      const updated = [...existingRelated, productId];
      batch.update(keywordRef, {
        related_product_ids: updated
      });
    }
  }

  await batch.commit();
  console.log(`✅ Product "${productId}" linked to keywords: ${keywordIds.join(", ")}`);
}

// Example usage
linkKeywordsToProduct("product3", ["keyword_eco", "keyword_jungle", "keyword_adventure"])
  .catch(console.error);
