require 'json'
require 'nokogiri'
require 'open-uri'
require 'singleton'

class Scraper
  include Singleton

  @url = 'http://pearljam.com/music'
  @filename = 'public/songs.json'

  def self.document_for(url)
    Nokogiri::HTML open url
  end

  def self.content_from(url)
    document_for(url).css 'body div#container div#main_content div'
  end

  def self.songs
    elements = content_from(@url)[3].css 'table tr.music_songs'

    [].tap do |songs|
      elements.each do |element|
        data = element.css 'td'

        if data[1].text == 'PJ Original'
          anchor = data[0].css('a')
          url = anchor.first['href']

          lyrics = lyrics_for(url)
          
          if lyrics && lyrics.any?
            songs << { name: anchor.text, lyrics: lyrics }
          end
        end
      end
    end
  end

  def self.lyrics_for(url)
    content = content_from(url)
    
    text = content.css('div.lyrics p').first.to_s
    text = text.sub('<p>', '').sub('</p>', '').sub('<span>', '').sub('</span>', '').sub('&nbsp;', '')
    text = text.strip.chomp('<br><br>').chomp('<br>')
    
    verse_chorus = text.split('<br><br>').compact
    
    empty = ['<br>', 'Not Available', 'Lyrics Not Available']
    return nil if verse_chorus.size == 1 && @empty_lyrics.include?(verse_chorus.first)
    
    verse_chorus.map { |vc| vc.split '<br>' }
  rescue
  end

  def self.run
    file = Kernel.open(@filename, 'w')
    JSON.dump({ songs: songs }, file)
  end

end

Scraper.run