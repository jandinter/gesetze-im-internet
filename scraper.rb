require 'down'
require 'nokogiri'
require 'pathname'
require 'uri'
require 'zip'

TOC_PATH = 'https://www.gesetze-im-internet.de/gii-toc.xml'.freeze
HOST_NAME = 'https://www.gesetze-im-internet.de'.freeze
MAX_SIZE_FOR_FILES = 30 * 1024**2 # in MiB
DOWNLOAD_FOLDER = 'gesetze'.freeze

class Object
  def logger
    puts self
    self
  end
end

class Toc
  include Enumerable

  def initialize(xml)
    @entries = Nokogiri::XML::Document
    .parse(xml)
    .search('items', 'item')
    .select { |item| !item.at_xpath('link').nil? && !item.at_xpath('title').nil? }
    .map do |item|
      TocEntry.new(name: item.at_xpath('title').content,
        uri: item.at_xpath('link').content)
    end

    puts @entries.count
  end

  def entries
    @entries
  end
end

class TocEntry
  attr_reader :name, :uri

  def initialize(name:, uri:)
    @name = name
    @uri = URI.parse(uri)
    @short_name
  end

  def short_name
    @short_name ||= Pathname.new(uri.path).dirname.to_s.delete('/').to_s
  end
end

toc_string = Down.download(TOC_PATH)

toc = Toc.new(toc_string)

begin
  toc.entries.each do |item|
    puts item
    zip_file = Down.download(item.uri, max_size: MAX_SIZE_FOR_FILES)
    puts zip_file.size
    file_name = File.join(Pathname.getwd, DOWNLOAD_FOLDER,
                (Pathname.new(item.uri.path).dirname.to_s.delete('/').to_s +
                '.xml'))
    Zip::File.open(zip_file) do |files|
      Zip.on_exists_proc = true
      entry = files.glob('*.xml').first
      raise 'File too large when extracted' if entry.size > MAX_SIZE_FOR_FILES

      files.extract(entry, file_name)
    end
  end
end


