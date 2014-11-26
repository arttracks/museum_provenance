    require 'museum_provenance'

    provenance_text = "Artist estate; Michel Monet, son of the artist, Sorel Moussel, Dept. Eure et Loire, 1926; Walter P. Chrysler, Jr., New York, NY, 1950; purchased by Museum, April 1962."

    timeline = MuseumProvenance::Provenance.extract provenance_text

    puts JSON.pretty_generate(JSON.parse(timeline.to_json))
