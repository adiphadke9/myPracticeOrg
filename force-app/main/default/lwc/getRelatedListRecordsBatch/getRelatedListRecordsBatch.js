// wireGetRelatedListRecordsBatch.js
import { LightningElement, wire } from "lwc";
import { getRelatedListRecordsBatch } from "lightning/uiRelatedListApi";
export default class WireGetRelatedListRecordsBatch extends LightningElement {
  error;
  results;
  @wire(getRelatedListRecordsBatch, {
    parentRecordId: "001RM000003UNu6YAG",
    relatedListParameters: [
      {
        relatedListId: "Contacts",
        fields: ["Contact.Name", "Contact.Id"],
        sortBy: ["Contact.Name"],
      },
      {
        relatedListId: "Opportunities",
        fields: ["Opportunity.Name", "Opportunity.Amount"],
        sortBy: ["Opportunity.Amount"],
      },
    ],
  })
  listInfo({ error, data }) {
    if (data) {
      this.results = data.results;
      this.results.forEach(records => {
        console.log(records);   
      });
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.results = undefined;
    }
  }
}