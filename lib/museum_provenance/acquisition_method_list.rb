module MuseumProvenance
    class AcquisitionMethod
    # Given in a will
    BEQUEST = AcquisitionMethod.new("Bequest", "bequest to", "by bequest", "Given in a will", AcquisitionMethod::Prefix, ['bequeathed to'])
    
    # Transfer from anscestor via unknown means
    BY_DESCENT = AcquisitionMethod.new("By descent", "by descent to", "by descent", "Transfer from anscestor via unknown means", AcquisitionMethod::Prefix, ['by inheritance to', "by inheritance"])
   
    # Transfer from several anscestor via unknown means
    BY_DESCENT_THROUGH = AcquisitionMethod.new("By descent through", "by descent through", nil, "Transfer from several anscestors via unknown means", AcquisitionMethod::Prefix)

    # Direct purchase, without an agent
    SALE = AcquisitionMethod.new("Sale", "sold to", nil, "Direct purchase, without an agent", AcquisitionMethod::Prefix, ["sold"])

    # Direct purchase, without an agent
    PRIVATE_SALE = AcquisitionMethod.new("Private Sale", "sold privately to", nil, "Direct purchase, without an agent or gallery", AcquisitionMethod::Prefix, "sold privately")
    
    # Purchase, possibly with an agent
    PURCHASE = AcquisitionMethod.new("Purchase", "purchased by", nil, "Purchase, possibly with an agent", AcquisitionMethod::Prefix, ['bought at sale by', "bought by", "by purchase", "purchased"])
    
    # Purchase, via an agent
    AGENT_PURCHASE = AcquisitionMethod.new("Purchase via Agent", "purchased for", nil, "Purchase, via an agent", AcquisitionMethod::Prefix, ["as agent for"])
    
    # Obtained not necesssarily by direct purchase
    ACQUISITION = AcquisitionMethod.new("Acquisition", "acquired by", "by acquisition", "Obtained not necesssarily by direct purchase", AcquisitionMethod::Prefix)
    
    #Obtained via an auction
    AUCTION = AcquisitionMethod.new("Auction", "by auction, to", "by auction", "Obtained via an auction", AcquisitionMethod::Suffix)
    
    #Obtained via an exchange
    EXCHANGE = AcquisitionMethod.new("Exchange", "by exchange, to", "by exchange", "Obtained via an exchange", AcquisitionMethod::Suffix, "acquired by exchange")
    
    #A different work was gifted, that work was exchanged for this
    GIFT_BY_EXCHANGE = AcquisitionMethod.new("Gift, by exchange", "gift by exchange, to", "gift, by exchange", "a different work was gifted, that work was exchanged for this", AcquisitionMethod::Suffix)
    
    #a different work was bequested, that work was exchanged for this
    BEQUEST_BY_EXCHANGE = AcquisitionMethod.new("Bequest, by exchange", "bequest by exchange, to", "bequest, by exchange", "a different work was bequested, that work was exchanged for this", AcquisitionMethod::Suffix)
    
    # Gift
    GIFT = AcquisitionMethod.new("Gift", "gift to", nil, "Gift", AcquisitionMethod::Prefix, ["gifted to", "donated to", "given to"])
    
    #Acquisition without legal right
    CONVERSION = AcquisitionMethod.new("Conversion", "by conversion, to", "by conversion", "Acquisition without legal right", AcquisitionMethod::Prefix, ["confiscated by"])
    
    #Acquisition by illegal means
    LOOTING = AcquisitionMethod.new("Looting", "looted by", "by theft", "Acquisition by illegal means", AcquisitionMethod::Prefix, ["stolen by"])
    
    #Purchased via a forced sale
    FORCED_SALE = AcquisitionMethod.new("Forced Sale", "forced sale, to", "by forced sale", "Purchased via a forced sale", AcquisitionMethod::Suffix)
    
    #Returned to original owner after an improper acquisition
    RESTITUTION = AcquisitionMethod.new("Restitution", "restituted to", "by restitution", "Returned to original owner after an improper acquisition", AcquisitionMethod::Prefix)
    
    #Sometime seen after looted work is returned.
    #@todo confirm
    TRANSFER = AcquisitionMethod.new("Transfer", "transferred to", "by transfer", "??? Sometime seen after looted work is returned ???", AcquisitionMethod::Prefix)
    
    #work acquired via artist commission
    COMMISSION = AcquisitionMethod.new("Commission", "commissioned by", "by commission", "work acquired via artist commission", AcquisitionMethod::Prefix, ["by commission, to", "painted for", "created for"])
    
    #Acquired via collection in a field
    FIELD_COLLECTION = AcquisitionMethod.new("Field Collection", "field collected by", "by field collection", "Acquired via collection in a field", AcquisitionMethod::Prefix)
    
    #Present, but ownership unknown
    WITH = AcquisitionMethod.new("With", "with", nil, "Present, but ownership unknown", AcquisitionMethod::Prefix)
    
    #for sale at a gallery
    FOR_SALE = AcquisitionMethod.new("For Sale", "sold at", nil, "for sale at a gallery", AcquisitionMethod::Prefix, ["sold at auction", "sold at auction,", "sold at auction to"])
    
    #for sale at a gallery, but not sold
    IN_SALE = AcquisitionMethod.new("In Sale", "In sale at", "sale", "for sale at a gallery, but not sold", AcquisitionMethod::Suffix)
    
    #As an agent for someone else
    AS_AGENT = AcquisitionMethod.new("As Agent", nil , "as agent", "As an agent for someone else", AcquisitionMethod::Suffix)
 
    # On deposit at 
    ON_DEPOSIT = AcquisitionMethod.new("On Deposit", "on long-term at", nil, "Located at the museum, but not owned by the museum", AcquisitionMethod::Prefix, ["on deposit", "on deposit at", "on long term at", "on longterm loan at", "on extended loan at"])
   
  end
end