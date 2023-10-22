// const { GoogleSpreadsheet } = require('google-spreadsheet')

// const API_KEY = '<>' // See: https://developers.google.com/sheets/api/guides/authorizing#APIKey
// const SHEET_ID = '<1PCXn3xrkgtivNgtkO-pCK65ctD0LsKPTX_iKFL2CqmA>' // spreadsheet key is the long id in the sheets URL

// const doc = new GoogleSpreadsheet(SHEET_ID)
// doc.useApiKey(API_KEY)

// ;(async function (){

// // https://theoephraim.github.io/node-google-spreadsheet/#/classes/google-spreadsheet-worksheet
// await doc.loadInfo() // loads document properties and worksheets
//  //console.log('>>', doc.title)

// // https://theoephraim.github.io/node-google-spreadsheet/#/classes/google-spreadsheet-worksheet?id=basic-sheet-properties
// const sheet = doc.sheetsByIndex[0]
// const rows = await sheet.getRows({ offset:0, /*limit:5*/ })

// console.log('# ' + rows[0]._sheet.headerValues.join(','))
// for (const row of rows) {
//   console.log(row._rawData.join(','))
// }

// }())