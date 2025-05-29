const admin = require("firebase-admin");
const serviceAccount = require("./trombol-db-firebase-adminsdk-fbsvc-4ebea014b9.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const keywords = [
  {
    keyword_ID: 34672,
    keyword_lastSearched: new Date(),
    keyword_relatedProdID: "/collection/product1",
    keyword_str: "mountain, cave, trail, adventure, budget"
  },
  {
    keyword_ID: 34673,
    keyword_lastSearched: new Date(),
    keyword_relatedProdID: "/collection/product2",
    keyword_str: "city, nightlife, food, shopping, museum"
  },
  {
    keyword_ID: 34674,
    keyword_lastSearched: new Date(),
    keyword_relatedProdID: "/collection/product3",
    keyword_str: "jungle, rain, eco-tour, exotic, hike"
  }
];

async function insertKeywords() {
  const batch = db.batch();

  keywords.forEach((keyword) => {
    const docRef = db.collection("Keyword").doc(); // Auto ID
    batch.set(docRef, keyword);
  });

  await batch.commit();
  console.log("✅ Keywords added successfully!");
}

insertKeywords().catch(console.error);
