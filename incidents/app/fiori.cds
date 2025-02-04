using { acme.incmgt } from '../db/schema';
using { IncidentsService, acme.incmgt.Incidents, cuid } from '../srv/incidents-service';

annotate cuid:ID with @title: 'ID';
@odata.draft.enabled
annotate IncidentsService.Incidents with @(UI : {

  // For Lists of Incidents
  SelectionFields : [ urgency_code, status_code, service.type ],
  LineItem : [
    { Value: title },
    { Value: urgency.name, Criticality : #Critical, CriticalityRepresentation : #WithoutIcon, },
    { Value: status.name },
    { Value: service.type },
  ],

  // Information for the header area of Details Pages
  HeaderInfo : {
    TypeName     : 'Incident',
    TypeNamePlural : 'Incidents',
    TypeImageUrl   : 'sap-icon://alert',
    Title      : { Value: title },
  },

  // Facets for additional object header information (shown in the object page header)
  HeaderFacets : [{
    $Type  : 'UI.ReferenceFacet',
    Target : '@UI.FieldGroup#HeaderGeneralInformation'
  }],

  // Facets for Details Page of Incidents
  Facets : [
    { Label: 'Overview', ID:'OverviewFacet', $Type: 'UI.CollectionFacet', Facets : [
      { Label: 'General Information', $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#GeneralInformation' },
      { Label: 'Details', $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#IncidentDetails' },
    ]},
    { Label: 'Conversation', $Type: 'UI.ReferenceFacet', Target: 'conversation/@UI.LineItem' }
  ],

  FieldGroup #HeaderGeneralInformation : {
    Data : [
      { Value: urgency.name },
      { Value: status.name },
      { Value: service.type },
      { Label: 'Worker', $Type  : 'UI.DataFieldForAnnotation', Target : 'service/worker/@Communication.Contact' }
    ]
  },

  FieldGroup #IncidentDetails : {
    Data : [
      { Value: ID },
      { Value: title },
     ]
  },

  FieldGroup #GeneralInformation: {
    Data : [
      { Value: urgency.name },
      { Value: service.type },
      { Value: status.name, },
    ],
  },

});


annotate IncidentsService.Conversation with @(UI : {

  LineItem : [
    { Value: timestamp },
    { Value: author },
    { Value: message }
  ],

  HeaderInfo : {
    TypeName       : 'Message',
    TypeNamePlural : 'Messages',
    Title          : { Value: message },
    Description    : { Value: timestamp },
  },

  Facets : [
    { Label: 'Details', $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#MessageDetails' },
  ],
  FieldGroup #MessageDetails : {
    Data: [
      { Value: message }
    ]
  }
});


annotate IncidentsService.ServiceWorkers with @(Communication.Contact : {
  fn   : name,
  kind : #individual,
  role : role,
});


annotate IncidentsService.Appointments with @(UI : {
  LineItem : [
    { Value: start_date },
    { Value: end_date },
    { Value: worker.name, Label : 'Assigned' }
  ]
});


// TODO: proper use of code lists with value help
annotate incmgt.Urgencies with {
  @Common : { 
    Text : descr,
    TextArrangement : #TextOnly,
  }
  code;

  @title : 'Urgency'
  name;
};

annotate incmgt.Statuses with {
  @Common : { 
    Text : descr,
    TextArrangement : #TextOnly,
  }
  code;

  @title : 'Status'
  name;
};



// REVISIT: this is needed to make the 'conversation/@UI.LineItem' path work
extend service IncidentsService with {
  entity Conversation as projection on Incidents.conversation;
}