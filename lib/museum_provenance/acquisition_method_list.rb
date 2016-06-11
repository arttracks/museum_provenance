module MuseumProvenance
  class AcquisitionMethod
    ###############################################################################
    TRANSFER_DESCRIPTION = <<-eos

    ## Transfer of an Object

    This category of events represents the transfer of ownership of an object 
    from one party to another.  This includes transfers that involve the
    exchange of value, such as purchases or exchanges.  This also includes 
    transfers that do not involve the exchange of value, such as gifts or bequests.
    This also includes transfers through illegal means, such as theft or looting.

    By default, all events in a provenance record as assumed to be this type of
    event.  

    eos

    AcquisitionMethod.new({
      id:                 :acquisition,
      title:              "Acquisition", 
      prefix:             "", 
      suffix:             "by acquisition",
      description:        "This object was acquired by the named party in an unknown fashion.",
      explanation:        "This is the default method for acquisitions and is the base type for all acquisitions.It should be used if there are no additional details available.  If there is not an explicit acquisition method mentioned, this will be assumed.",
      preferred_form:     AcquisitionMethod::Prefix, 
      synonyms:           ["acquired by"],
      parent:             nil,
      type:               :acquisition,
      custody_transfer:   true,
      ownership_transfer: true,
      class_description:  TRANSFER_DESCRIPTION
    }) 


    # AcquisitionMethod.new({
    #   id:                 :acquisition_for,
    #   title:              "Acquisition For", 
    #   prefix:             "acquired for", 
    #   description:        "This object was acquired by the named party in some manner, but the named party did not take custody of the object.",
    #   explanation:        "This is the generic method for ownership-only transfers.  It will generally only be used by automated systems that cannot deduce a subtype, and should rarely be manually used.",
    #   preferred_form:     AcquisitionMethod::Prefix, 
    #   synonyms:           [],
    #   parent:             :acquisition,
    #   custody_transfer:   false,
    # }) 


    # TODO:  Is there a better word for this?
    AcquisitionMethod.new({
      id:              :exhange_of_value,
      title:           "Exchange of Value", 
      suffix:          "through an exchange of value", 
      description:     "This object was obtained in some manner by the named party through an exchange of value.",
      explanation:     "This is the base class for all transfers where something of value was exchanged between the acquiring party and the receiving party.  This does not specify any details about the manner of the sale or the type of value exchanged.  In general, if it is assumed that money was exchanged, use 'purchased by'",
      preferred_form:  AcquisitionMethod::Suffix, 
      synonyms:        [],
      parent:          :acquisition,
    }) 

    AcquisitionMethod.new({
      id:              :sale,
      title:           "Sale", 
      prefix:          "purchased by", 
      description:     "This object was purchased by the named party.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [ "bought by", "by purchase", "purchased", "sold to"],
      parent:          :exhange_of_value,
    }) 


    AcquisitionMethod.new({
      id:              :sale_for,
      title:           "Sale For", 
      prefix:          "purchased for", 
      description:     "This object was purchased by the named party, but the named party did not take custody of the object.",
      preferred_form:  AcquisitionMethod::Prefix, 
      parent:          :sale,
      custody_transfer: false

    }) 

    AcquisitionMethod.new({
      id:              :private_sale,
      title:           "Private Sale", 
      prefix:          "privately purchased by", 
      description:     "This object was purchased by the named party from another party in a sale that was not publicly advertised and/or available.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ["sold privately"],
      parent:          :sale,
    }) 

    AcquisitionMethod.new({
      id:              :private_sale_for,
      title:           "Private Sale For", 
      prefix:          "privately purchased for", 
      description:     "This object was purchased by the named party from another party in a sale that was not publicly advertised and/or available, but the named party did not take custody of the object.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :private_sale,
      custody_transfer: false
    }) 

    AcquisitionMethod.new({
      id:              :purchase_at_auction,
      title:           "Purchase at Auction", 
      prefix:          "purchased at auction by", 
      description:     "This object was purchased by the named party at auction.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ["by auction, to","by auction","sold at auction", "sold at auction to", 'bought at sale by',],
      parent:          :sale,
    }) 

    AcquisitionMethod.new({
      id:              :purchase_at_auction_for,
      title:           "Purchase at Auction For", 
      prefix:          "purchased at auction for", 
      description:     "This object was purchased by the named party at auction, but the named party did not take custody of the object.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :purchase_at_auction,
      custody_transfer: false
    }) 

    AcquisitionMethod.new({
      id:              :exchange,
      title:           "Exchange", 
      suffix:          "by exchange", 
      prefix:          "by exchange, to",
      description:     "This object was acquired by the named party, but something of value was exchanged for the object instead of money.",
      preferred_form:  AcquisitionMethod::Suffix, 
      synonyms:        ['acquired by exchange'],
      parent:          :exhange_of_value,
    }) 


    AcquisitionMethod.new({
      id:              :forced_sale,
      title:           "Forced Sale", 
      suffix:          "by forced sale", 
      prefix:          "forced sale, to",
      description:     "This object was purchased by the named party using involuntary pressure on the seller.",
      preferred_form:  AcquisitionMethod::Suffix, 
      synonyms:        [],
      parent:          :sale,
    }) 

    AcquisitionMethod.new({
      id:              :assumption,
      title:           "Assumption of Ownership", 
      prefix:          "ownership assumed by", 
      description:     "This object was acquired by the named party in some way that did not involve an exchange of value.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :acquisition,
    }) 



    AcquisitionMethod.new({
      id:              :appropriation,
      title:           "Appropriation", 
      prefix:          "appropriated by", 
      description:     "This object was acquired by the named party without the consent of and without an exchange of value to the previous owner.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :assumption,
    }) 


    AcquisitionMethod.new({
      id:              :confiscation,
      title:           "Confiscation", 
      prefix:          "confiscated by", 
      description:     "This object was legally appropriated by an entity without the consent of the previous owner.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :appropriation,
    }) 


    AcquisitionMethod.new({
      id:              :theft,
      title:           "Theft", 
      prefix:          "stolen by", 
      suffix:          "by theft",
      description:     "This object was stolen by the named party.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ["via theft"],
      parent:          :appropriation,
    }) 

    AcquisitionMethod.new({
      id:              :looting,
      title:           "Looting", 
      prefix:          "looted by", 
      description:     "This object was looted during a conflict by the named party.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :theft,
    }) 

    AcquisitionMethod.new({
      id:              :restitution,
      title:           "Restitution", 
      prefix:          "restituted to", 
      suffix:          "by restitution",
      description:     "This object was returned to the named party after having previously been illegally taken from them.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ["via restitution"],
      parent:          :appropriation,
    }) 

    AcquisitionMethod.new({
      id:              :conversion,
      title:           "Conversion", 
      prefix:          "appropriated by", 
      suffix:          "by appropriation",
      description:     "This object was acquired by the named party through some form of eminent domain.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [ "by conversion, to", "by conversion"],
      parent:          :confiscation,
    }) 

    AcquisitionMethod.new({
      id:              :gift,
      title:           "Gift", 
      prefix:          "gift to", 
      description:     "This object was given to the named party.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ["gifted to", "donated to", "given to"],
      parent:          :assumption,
    }) 


    AcquisitionMethod.new({
      id:              :transfer,
      title:           "Transfer", 
      prefix:          "transferred to", 
      suffix:          "by transfer",
      description:     "This object was given to the named party from another part or element of the same named party.",
      explanation:     "This is typically used for objects transferring from one department to another within an organization.  It is NOT used for moments when an organization changes legal form;  see `by consolidation` for that.  This is also often used when an item is transferring from some form of partial ownership to being completely owned by one of the partial owners.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        [],
      parent:          :gift,
    }) 

    AcquisitionMethod.new({
      id:              :bequest,
      title:           "Bequest", 
      prefix:          "bequest, to", 
      suffix:          "by bequest",
      description:     "This object was given to the named party through a will or other means following the death of the previous owner.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ['bequeathed to'],
      parent:          :gift,
    }) 

    AcquisitionMethod.new({
      id:              :by_descent,
      title:           "By Descent", 
      suffix:          "by descent",
      prefix:          "by descent to", 
      description:     "This object was given to the named party following the death of a previous owner who was their family member.",
      explanation:     "Note that this does not include the automatic transfer to a spouse following post WWII property law.   See 'via marriage' for those instances.",
      preferred_form:  AcquisitionMethod::Prefix, 
      synonyms:        ['by inheritance to', "by inheritance"],
      parent:          :bequest,
    }) 

    ###############################################################################
    INSTANTIATION_DESCRIPTION = <<-eos

    ## Origination of an Object.

    This category of events describe the beginning of an object.  This may
    represent the creation of an object or the moment in which the object began
    to be perceived as an art object.  This relates to the specific physical or 
    conceptual object being described; for instance, this could describe the a 
    specific print of a photograph OR the conceptual entity of the photo, 
    but should not be used to record both in a single provenance record.

    All objects are assumed to have be originated. Origination MUST be the first
    event in the provenance of an object.  If a record does not have an origination
    event as the first event in the provenance, a generic origination event with
    no date and an unknown party is assumed.

    eos

    AcquisitionMethod.new({
      id:                 :origin,
      title:              "Origination", 
      prefix:             "gave origin by", 
      description:        "This object was brought into existence in some manner.",
      explanation:        "This is the most general form of origination.  It does not specify any particulars about the origination event, only that it existed and some party had agency in then origination.",
      preferred_form:     AcquisitionMethod::Prefix, 
      synonyms:           [],
      parent:             nil,
      type:               :instantiation,
      custody_transfer:   true,
      ownership_transfer: true,
      class_description:  INSTANTIATION_DESCRIPTION
    }) 

    AcquisitionMethod.new({
      id:             :creation,
      title:          "Creation", 
      prefix:         "created by",  
      description:    "This object was created by the named party.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :origin,
    }) 


    AcquisitionMethod.new({
      id:             :found,
      title:          "Found", 
      prefix:         "found by",  
      description:    "This object was found by the named party.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["discovered by"],
      parent:         :origin,
    }) 

    AcquisitionMethod.new({
      id:             :recognization,
      title:          "Recognization", 
      prefix:         "recognized by",  
      description:    "This object was recognized as an artistic object by the named party.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :found,
    }) 


    AcquisitionMethod.new({
      id:             :discovery,
      title:          "Discovery", 
      prefix:         "discovered by", 
      description:    "This object was discovered by the named party as part of an archaeological event.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :found,
    }) 

    AcquisitionMethod.new({
      id:             :field_collection,
      title:          "Field Collection", 
      prefix:         "field collected by", 
      suffix:         "by field collection", 
      description:    "This object was collected by the named party as part of an archaeological event.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :found,
    }) 

    AcquisitionMethod.new({
      id:             :conceptualization,
      title:          "Conceptualization", 
      prefix:         "conceptualized by",  
      description:    "This abstract object was conceived by the named party as an artistic object.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :creation,
    })

    AcquisitionMethod.new({
      id:             :fabrication,
      title:          "Fabrication", 
      prefix:         "fabricated by",  
      description:    "A physical instance of a conceptual object was created by the named party.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["published by", "printed by"],
      parent:         :creation,
    })

    AcquisitionMethod.new({
      id:             :commission,
      title:          "Commission", 
      prefix:         "commissioned by",  
      suffix:         "by commission",
      description:    "This object was commissioned by the named party.",
      explanation:    "Note that this does not assume the named party received custody of the object. Typically, this would be followed by an agent who would be the fabricator, and then by a delivery of the object to the named party.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["by commission, to", "painted for", "created for"],
      parent:         :creation,
      custody_transfer: false
    })


    AcquisitionMethod.new({
      id:                 :fabrication_for,
      title:              "Fabrication For", 
      prefix:             "fabricated for",  
      description:        "A physical instance of a conceptual object was created for the named party, but they did not immediately have custody.",
      explanation:        "This is typically used when an object is being fabricated by a third party, but explicitly for someone.  If you are using this, and not the usual 'Fabricated', you typically would indicate the fabricator as agent in the immediately following event.",
      preferred_form:     AcquisitionMethod::Prefix, 
      synonyms:           [],
      parent:             :fabrication,
      custody_transfer:   false
    })


    ###############################################################################

    DISBODIMENT_DESCRIPTION = <<-eos

    ## Disappearance of an Object.

    This category of events indicates that the object being described no longer
    exists to the best knowledge of the author.  Objects which have been 
    destroyed fall into this category, as do objects which have been lost
    permanently.  This can also be used to describe the completion of objects 
    that are only intended to exist for a finite length of time.  

    By default, objects have not disappeared.  If an object is believed to no 
    longer exist, this SHOULD be recorded.

    If recorded, this MUST be the final entry in a provenance record. There MUST
    be at most one disappearance event for an object.

    There MAY be an party recorded with these events.

    eos

    AcquisitionMethod.new({
      id:             :disappearance,
      title:          "Disappearance", 
      prefix:         "disappeared by", 
      description:    "This object was removed from existence in some manner.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :nil,
      type:           :disappearance,
      custody_transfer:   true,
      ownership_transfer: true,
      class_description:  DISBODIMENT_DESCRIPTION
    }) 

    AcquisitionMethod.new({
      id:             :destruction,
      title:          "Physical Destruction", 
      prefix:         "destroyed by", 
      description:    "This object was permanently destroyed.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :disappearance,
    }) 

    AcquisitionMethod.new({
      id:             :expiration,
      title:          "Expiration", 
      prefix:         "completed by", 
      description:    "This object came to its intended temporal ending.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :disappearance,
    }) 

    AcquisitionMethod.new({
      id:             :lost,
      title:          "Loss", 
      prefix:         "lost by", 
      description:    "This object has been lost and is not believed to be findable.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :disappearance,
    }) 


    ###############################################################################
    DIVISION_DESCRIPTION = <<-eos

    ## Division of Custody & Ownership

    This category of events describe moments where custody, but NOT ownership 
    of an object is given to a party.  This is used for consignment, for loans,
    and when one party is acting as a representative or agent for another.

    eos

    AcquisitionMethod.new({
      id:             :possessed_by,
      title:          "In Possession", 
      prefix:         "in custody of", 
      description:    "The named party has temporary custody, but not ownership of this object.",
      explanation:    "By default, ownership is assumed in this model.  This is used to explicitly indicate that the named party does NOT have ownership of the object.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["with"],
      parent:         nil,
      type:           :divided_custody,
      custody_transfer:   true,
      ownership_transfer: false,
      class_description:  DIVISION_DESCRIPTION
    }) 


    AcquisitionMethod.new({
      id:             :as_agent,
      title:          "As Agent", 
      suffix:         "as agent", 
      description:    "The named party has temporary custody as an agent or representative of the owner.",
      explanation:    "An agent is acting as a proxy and in the interests of another party, but does not take ownership of the work.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       ["as agent for"],
      parent:         :possessed_by,
    }) 

    AcquisitionMethod.new({
      id:             :as_trustee,
      title:          "As Trustee", 
      suffix:         "as trustee", 
      description:    "The named party has temporary custody as trustee for an owner who is not legally capable of being responsible for the object.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       [],
      parent:         :as_agent,
    }) 

    AcquisitionMethod.new({
      id:             :on_deposit,
      title:          "On Deposit", 
      prefix:         "on deposit to", 
      description:    "The named party has been given temporary custody without permission to sell or exhibit the object.",
      explanation:    "This differs from `on loan` chiefly when the temporary custody is done for the owner's benefit, not the temporary custodian's benefit.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["on deposit", "on deposit at"],
      parent:         :possessed_by,
    }) 


    AcquisitionMethod.new({
      id:             :consignment,
      title:          "Consigned", 
      prefix:         "consigned to", 
      description:    "The named party has been given custody with the intent for them to sell the object.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["In sale at", "sale", "sold by", "sold at", "sale,"],
      parent:         :on_deposit,
    }) 

    AcquisitionMethod.new({
      id:             :on_loan,
      title:          "On Loan", 
      prefix:         "loaned to", 
      description:    "The named party has been given temporary custody for use, but without permission to sell the object.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       ["on loan to", "on permanent loan to", "on long term at", "on longterm loan at", "on extended loan at"],
      parent:         :on_deposit,
    }) 

    AcquisitionMethod.new({
      id:             :on_tour,
      title:          "On Tour", 
      prefix:         "toured to", 
      description:    "The named party has been granted custody as part of a series of loans.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :on_loan,
    }) 


    ###############################################################################
    REJOINING_DESCRIPTION = <<-eos

    ## Rejoining of Custody & Ownership

    This category of events describe moments where the custody and ownership of
    an object are reunited in a single party.  This implies that the party named 
    in the immediately preceding event did not have ownership of the object, 
    and thus MUST either follow a custody division event or a break in knowledge.

    The party described is the receiving party, and they MUST already have 
    been named as the owning entity.

    eos

    AcquisitionMethod.new({
      id:             :delivered,
      title:          "Delivered", 
      prefix:         "delivered to", 
      description:    "This object was delivered to the owning party by a party which had temporary custody.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         nil,
      type:           :rejoining,
      custody_transfer:   true,
      ownership_transfer: false,
      class_description:  REJOINING_DESCRIPTION
    }) 

    AcquisitionMethod.new({
      id:             :returned,
      title:          "Returned", 
      prefix:         "returned to", 
      description:    "This object was returned to the owning party from a party which had temporary custody.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         :delivered,
    }) 

    ###############################################################################

    TRANSFORMATION_DESCRIPTION = <<-eos

    ## Transformation of Party

    This category of changes are used to handle instances in which an party
    becomes another party through some sort of legal change.  This is explicitly
    not for name changes; in that case the party remains the same party.  However,
    this is used to record changes via marriages, corporate mergers, or widowhood.

    eos

    AcquisitionMethod.new({
      id:             :party_transformation,
      title:          "Party Transformation", 
      prefix:         "who became", 
      description:    "One legal party has transformed itself another legal party.",
      preferred_form: AcquisitionMethod::Prefix, 
      synonyms:       [],
      parent:         nil,
      type:           :transformation,
      custody_transfer:   true,
      ownership_transfer: true,
      class_description:  TRANSFORMATION_DESCRIPTION

    })

    AcquisitionMethod.new({
      id:             :marriage,
      title:          "Marriage", 
      suffix:         "via marriage", 
      description:    "One individual has married another, and ownership is now shared.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       [],
      parent:         :party_transformation,

    }) 

    AcquisitionMethod.new({
      id:             :widowhood,
      title:          "Widowhood", 
      suffix:         "via widowhood", 
      description:    "One individual in a marriage has died, and ownership is assumed by the surviving party.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       [],
      parent:         :party_transformation,

    }) 

    AcquisitionMethod.new({
      id:             :divorce,
      title:          "Divorce", 
      suffix:         "via divorce", 
      description:    "A marriage has been legally dissolved, and ownership has been assumed by one of the married parties.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       [],
      parent:         :party_transformation,
    }) 

    AcquisitionMethod.new({
      id:             :death,
      title:          "Death", 
      suffix:         "via death", 
      description:    "This is used for the transfer to an estate from a party who has died.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       ["via his death", "via her death", "via their death"],
      parent:         :party_transformation,
    }) 

    AcquisitionMethod.new({
      id:             :partial_gift,
      title:          "Partial Gift", 
      suffix:         "via partial gift", 
      description:    "This is used for the transfer from one party to a legal entity that includes both themselves and another party.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       ["partial gift to"],
      parent:         :party_transformation,
    }) 


    AcquisitionMethod.new({
      id:             :consolidation,
      title:          "Organizational Consolidation", 
      suffix:         "via consolidation", 
      description:    "One organization has joined with another organization, and the combined organization has assumed ownership.",
      preferred_form: AcquisitionMethod::Suffix, 
      synonyms:       [],
      parent:         :party_transformation,
    }) 
  end
end