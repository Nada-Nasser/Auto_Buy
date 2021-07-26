import * as firestoreDB from "firebase-admin";

/**
 * add a document and get its ID
 * @param {string} documentPath
 * @param {string} data
 * @return {string} ID.
 */
export async function addDocument(documentPath, data) {
  const reference = await firestoreDB
      .firestore().collection(documentPath).add(data);
  return reference.id;
}

/**
 * update a document value given its path
 * @param {string} collectionPath
 * @param {string} documentID
 * @param {object} value
 */
export async function updateDocumentField(collectionPath: string,
    documentID: string, value) {
  await firestoreDB.firestore()
      .collection(collectionPath)
      .doc(documentID)
      .update(value);
}
