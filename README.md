# `museum_provenance`

`museum_provenance` is a Ruby library developed to help cultural institutions manage and understand the provenance of the objects within their collection.  It does this by parsing semi-structured provenance texts into structured data.

The main entry point to the tool is the `MuseumProvenance::Provenance` class.  This is a static class designed to take both unstructured data and structured data and convert it into the tool's internal data structure.

Using the `extract` method, you can provide a provenance string and it will be parsed into a `Timeline`, which is the topmost representation of provenance within the tool.

The `museum_provenance` gem is a subproject of the [Art Tracks](http://blog.cmoa.org/tag/art-tracks/) project for the [Carnegie Museum of Art](http://www.cmoa.org) in Pittsburgh, PA.

## Installation

Add this line to your application's Gemfile:

    gem 'museum_provenance'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install museum_provenance

## Usage

```ruby
    require 'museum_provenance'

    provenance_text = "Artist estate; Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926; Walter P. Chrysler, Jr., New York, NY, 1950; purchased by Museum, April 1962."

    timeline = MuseumProvenance::Provenance.extract provenance_text

    puts timeline.to_json
```

----

## Data Structure

The basic data structure of a provenance record using `museum_provenance` is:

### a Timeline,

A `Timeline` represents the entire history of ownership of a single work. It is represented as a linked series of `Periods`, one per-owner of the artwork.  

### which contains one or more Periods,

A `Period` is the representation of a single disjoint period in time representing an single period of ownership or custody of a work.  Each period is modeled after a CIDOC-CRM period, and has a single `Party` and `Location` associated with the work.  Due to the inherent uncertainties of historical data, often periods are missing data, or the data contained within the record is uncertain or imprecise.

Each period is made up of four main components, and several qualifiers and modifiers,

#### each of which includes a Party,

The party is the individual, gallery, sale, dealer, company, museum or other organization who had custody or ownership of the artwork during this period.  

It is important to remember that this represents the owner of the work during this period, not the party that it was transferred from or the party that it will be transferred to.

> Gift of John Wayne, 1995;

is not a correct provenance record, because it conflates to periods of ownership into a single clause of provenance.  The correct way to model that relationship is:

> John Wayne; Gift to Carnegie Museum of Art, 1995.

That way both owners are captured, the transfer is recorded, and the recipient of the gift is explicit, not implicit.  

Due to the prevalence of sales and auctions within provenance, it is important to distinguish that this does not currently include custody changes that are related to loans or exhibitions—those are rarely captured within the provenance history.

Parties can also be uncertain; a question mark immediately following the name indicates that the name is uncertain.

#### an Acquisition Method,

**TODO:** Write this.

#### and a Location,

The location is the physical location of the artwork on earth during this periods.  It is a precise as 

Currently, provenance does not tend to record changes in this location during a period — a more complete representation would allow recording location changes within the purview of a single owner as separate events, but there little or no usage of this within existing records.

#### and a Beginning and an Ending.

Periods are made up of two events: the a acquisition of the work and the deacquisition of the work.  It is also important to realize that each deacquisition is also the following party's acquisition.

There are two similar ways to represent the the dates relevant to a period.  One is as a series of ownerships, the other as a series of transfers.  For example:

> George, 1950; Mary 1965.

This provenance record describes two periods of ownership—  George's ownership between 1950 and 1965, and Mary's ownership from 1965 onward.  

It also encodes two transfers:  George's acquisition from an unknown party (likely the artist) in 1950, and Mary's acquisition from George in 1965.

Both of these ways of thinking about the period are correct—they also both contain the same information.  It is also important to realize that in both of these models, there is still uncertainty.

We know that George acquired the painting in 1950; what that really means is that we know that he **acquired** the painting *between* January 1, 1950 and December 31, 1950 and he **deacquired** the painting *between* January 1, 1965 and December 31, 1965. 

So, we know that George **definitely** owned the work *between* December 31, 1950 and January 1, 1965, and that he **possibly** owned the work *between* January 1, 1950 and December 31, 1965. 

This distinction is important when discussing periods where this uncertainty is caused by date precision—it's even more important where this imprecision is caused by gaps in knowledge.

For instance, consider:

> George, by 1960 until sometime after 1962; Mary, in 1970. 

This record could refer to the same events as the previous representation; but it captures a fuzziness in our information with accuracy.

We know that George **acquired** the painting *after* 1960, we know that he **deacquired** the painting *between* 1962 and 1970, and we don't have an earliest date he could have owned it—worst case, it is the earliest possible date of creation of the work.  

This also means that George **definitely** owned the work *between* December 31, 1960 and January 1, 1962, and that he **possibly** owned the work *between* its creation and December 31, 1970.



## Contributing

1. Fork it ( https://github.com/cmoa/museum_provenance/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
