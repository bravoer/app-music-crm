import template from '/app/template.js';

export default [
    {
        path: '/musicians',
        format: 'text/csv',
        query: template`
SELECT ?voornaam ?achternaam ?email ?telefoon ?instrument ?straat ?nummer ?postcode ?gemeente WHERE { 
  ?g <http://mu.semte.ch/vocabularies/core/uuid> ${['group', 'string']} .

  ?s a <http://mu.semte.ch/vocabularies/ext/bravoer/Musician> ;
     <http://www.w3.org/2006/vcard/ns#hasGivenName> ?voornaam ;
     <http://www.w3.org/2006/vcard/ns#hasFamilyName> ?achternaam ;
     ^<http://www.w3.org/2006/vcard/ns#hasMember> ?g .

  OPTIONAL { 
    ?s <http://www.w3.org/2006/vcard/ns#hasEmail> ?emailUri .
    BIND(STRAFTER(STR(?emailUri), "mailto:") as ?email) 
  }
  OPTIONAL { 
    ?s <http://www.w3.org/2006/vcard/ns#hasTelephone>/<http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?telUri
    BIND(STRAFTER(STR(?telUri), "tel:") as ?telefoon)
  }
  OPTIONAL { ?s <http://mu.semte.ch/vocabularies/ext/music/instrument> ?instrument }
  OPTIONAL { 
    ?s <http://www.w3.org/ns/locn#address> ?address .
    ?address <http://www.w3.org/ns/locn#thoroughfare> ?straat .
    ?address <http://www.w3.org/ns/locn#poBox> ?nummer .
    ?address <http://www.w3.org/ns/locn#postCode> ?postcode .
    ?address <http://www.w3.org/ns/locn#postName> ?gemeente .
  }
} ORDER BY ?achternaam ?voornaam`
    },
    {
        path: '/sympathizers',
        format: 'text/csv',
        query: `
SELECT ?organizatie ?aanspreking ?voornaam ?achternaam ?email ?telefoon ?straat ?nummer ?postcode ?gemeente ?uitnodiging WHERE { 
  ?s a <http://mu.semte.ch/vocabularies/ext/bravoer/Sympathizer> .

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasOrganizationName> ?organizatie .
  }

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasHonorificPrefix> ?aanspreking .
  }

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasGivenName> ?voornaam .
  }

  OPTIONAL {
     ?s <http://www.w3.org/2006/vcard/ns#hasFamilyName> ?achternaam .
  }

  OPTIONAL { 
    ?s <http://www.w3.org/2006/vcard/ns#hasEmail> ?emailUri .
    BIND(STRAFTER(STR(?emailUri), "mailto:") as ?email) 
  }

  OPTIONAL { 
    ?s <http://www.w3.org/2006/vcard/ns#hasTelephone>/<http://www.w3.org/1999/02/22-rdf-syntax-ns#value> ?telUri
    BIND(STRAFTER(STR(?telUri), "tel:") as ?telefoon)
  }

  OPTIONAL { 
    ?s <http://www.w3.org/ns/locn#address> ?address .
    ?address <http://www.w3.org/ns/locn#thoroughfare> ?straat .
    ?address <http://www.w3.org/ns/locn#poBox> ?nummer .
    ?address <http://www.w3.org/ns/locn#postCode> ?postcode .
    ?address <http://www.w3.org/ns/locn#postName> ?gemeente .
  }

  OPTIONAL {
    ?s <http://mu.semte.ch/vocabularies/ext/bravoer/communicationsMedium> ?communication .
    BIND(IF(?communication = "paper", "Papier", "E-mail") as ?uitnodiging)
  }

} ORDER BY ?achternaam ?voornaam`
    }    
];
