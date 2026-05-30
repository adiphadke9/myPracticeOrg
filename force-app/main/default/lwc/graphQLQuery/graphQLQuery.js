import { LightningElement, wire } from 'lwc';
import { gql, graphql } from 'lightning/graphql';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'text' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
    { label: 'Annual Revenue', fieldName: 'AccountRevenue', type: 'currency' },
    { label: 'Rating', fieldName: 'AccountRating', type: 'text' }
];

export default class GraphQLQuery extends LightningElement {
    records;
    errors;
    searchValue = '';
    dataList = [];
    columnsList = columns;
    after = null;
    pageInfo;
    pageNumber = 1;
    totalCount = 0;
    pageSize = 5;
    isLoading = false;

    connectedCallback() {
        this.isLoading = true;
    }

    // 👇 Reactive getter for GraphQL variables
    get variables() {
        return {
            likeParam: `%${this.searchValue || ''}%`,
            limit: this.pageSize,
            after: this.after
        };
    }

    get DisableNext(){
        return !this.pageInfo || !this.pageInfo.hasNextPage;
    }

    get totalPages(){
        return Math.ceil(this.totalCount / this.pageSize);
    }

    // 🔍 Handle input change
    handleChange(event) {
        event.preventDefault();
        this.searchValue = event.target.value;
    }

    // ⏭ Handle next page
    handleNext(event) {
        event.preventDefault();
        this.isLoading = true;
        if (this.pageInfo && this.pageInfo.hasNextPage) {
            this.after = this.pageInfo.endCursor;
            this.pageNumber++;
        } else {
            this.after = null;
            this.pageNumber = 1;
        }
    }

    handleReset(event){
        this.after = null;
        this.pageNumber = 1;
        this.isLoading = true;
    }

    // ⏮ Handle previous page (optional)
    handlePrevious(event) {
        event.preventDefault();
        if (this.pageInfo && this.pageInfo.hasPreviousPage) {
            // Implement backward pagination if needed
            // (You'd need to store previous cursors or use bidirectional pagination)
            console.log('Previous page not yet implemented');
        }
    }

    // 🧠 Wire GraphQL Query
    @wire(graphql, {
        query: gql`
            query getContactsWithAccount($likeParam: String, $after: String, $limit: Int) {
                uiapi {
                    query {
                        Contact(
                            first: $limit
                            after: $after
                            orderBy: { Name: { order: ASC } }
                            where: {
                                Name: { like: $likeParam }
                                Account: { Name: { ne: null } }
                            }
                        ) {
                            edges {
                                node {
                                    Id
                                    Name {
                                        value
                                    }
                                    Email {
                                        value
                                    }
                                    CreatedDate {
                                        value
                                        displayValue
                                    }
                                    Account {
                                        Name {
                                            value
                                        }
                                        AnnualRevenue {
                                            value
                                            displayValue
                                        }
                                        Rating {
                                            value
                                        }
                                    }
                                }
                            }
                            totalCount
                            pageInfo {
                                hasNextPage
                                hasPreviousPage
                                startCursor
                                endCursor
                            }
                        }
                    }
                }
            }
        `,
        variables: '$variables'
    })
    wiredGraphQLResult({ errors, data }) {
        if (errors) {
            this.errors = errors;
            console.error('GraphQL error:', errors);
            this.isLoading = false;
        } else if (data) {
            this.records = data.uiapi.query.Contact.edges;
            this.pageInfo = data.uiapi.query.Contact.pageInfo;
            this.totalCount = data.uiapi.query.Contact.totalCount;
            this.dataList = this.records.map(item => ({
                Id: item.node.Id,
                Name: item.node.Name?.value,
                Email: item.node.Email?.value,
                CreatedDate: item.node.CreatedDate?.displayValue,
                AccountRevenue: item.node.Account?.AnnualRevenue?.displayValue,
                AccountRating: item.node.Account?.Rating?.value
            }));
            this.isLoading = false;
            console.log('GraphQL data:', this.records);
        }
    }
}
