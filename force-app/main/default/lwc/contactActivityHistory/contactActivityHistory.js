import { LightningElement, api, wire } from 'lwc';
import getData from '@salesforce/apex/ContactActivityHistoryController.getData';


export default class ContactActivityHistory extends LightningElement {

    
    columns = 
    [
        { label: 'Contact', fieldName: 'contactId',  sortable: 'true', type: 'url',
            typeAttributes: {
                label: { fieldName: 'contactName'},
                target: '_blank'
            } 
        },
        { label: 'Activity Date', fieldName: 'activityDate', type: 'date-local',  sortable: 'true' , editable: 'true',
            typeAttributes: {
                day: 'numeric',
                month: 'numeric',
                year: 'numeric'
            }
        },
        { label: 'Type', fieldName: 'type', type: 'text', sortable: true},
        { label: 'Activity', fieldName: 'eventId',  sortable: 'true', type: 'url',
            typeAttributes: {
                label: { fieldName: 'subtype'},
                target: '_blank'
            } 
        },
        /*
        { label: 'Subject', fieldName: 'subject', type: 'text', sortable: true},
        */
    ];

    @api recordId;
    data;
    error;  
    activity = [];

    get datatableHeight() {
        console.log('this.data.length');
        console.log(this.data.length);
        if (this.data.length > 3) {
            return 'height: 150px;';
        } else {
            return '';
        }
    }

    @wire(getData, {recordId: '$recordId'})
    data({error, data}) {
        if (data) {
            console.log('Activity Data:');
            console.log(data);
            this.data = (data.length == 0) ? null : data;
        } else if (error) {
            console.log('Activity Error');
            console.log(error);
            this.error = error;
        } 
    }





}