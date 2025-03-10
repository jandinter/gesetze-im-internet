# frozen_string_literal: true

require 'down/http'
require 'nokogiri'
require 'pathname'
require 'uri'
require 'zip'

TOC_PATH = 'https://www.gesetze-im-internet.de/gii-toc.xml'
HOST_NAME_FOR_DOWNLOADS = 'https://www.gesetze-im-internet.de' # http, not https!
MAX_SIZE_FOR_FILES = 30 * 1024**2 # in MiB
DOWNLOAD_FOLDER = 'gesetze'

class Toc
  include Enumerable

  attr_reader :entries

  def initialize(xml)
    @entries = Nokogiri::XML::Document
    .parse(xml)
    .search('items', 'item')
    .select { |item| !item.at_xpath('link').nil? && !item.at_xpath('title').nil? }
    .map do |item|
      TocEntry.new(name: item.at_xpath('title').content,
      uri: item.at_xpath('link').content)
    end
  end
end

class TocEntry
  attr_reader :name, :uri

  def initialize(name:, uri:)
    @name = name
    @uri = URI.parse(uri)
  end

  def short_name
    @short_name ||= Pathname.new(uri.path).dirname.to_s.delete('/').to_s
  end

  def to_s
    "#{self}: #{@name}, #{@uri}"
  end
end

class ErrorLogger
  def intialize
    @log_items = Array.new
  end

  def log (e, toc_entry)
    @log_items.push({error: e, toc_entry: toc_entry})
  end

  def all_errors
    @log_items
  end
end

toc_string = Down::Http.new.download(TOC_PATH)

toc = Toc.new(toc_string)

begin
  count = 1
  error_logger = ErrorLogger.new
  http = Down::Http.new do |client|
    client.timeout(connect: 10, read: 5)
  end
  toc.entries.each do |item|
    begin
      zip_file = http.download(item.uri)
      if zip_file
        path_name = File.join(Pathname.getwd,
                              DOWNLOAD_FOLDER,
                              item.short_name)
        Dir.mkdir(path_name) unless Dir.exist?(path_name)

        puts item.short_name

        Zip::File.open(zip_file) do |files|
          Zip.on_exists_proc = true
          files.each do |file|
            raise 'File too large when extracted' if file.size > MAX_SIZE_FOR_FILES
            file_name = File.join(path_name, file.name)
            files.extract(file, file_name) # Overwrite existing files
          end

          xml_file = Dir.glob("#{path_name}/*.xml").first
          if xml_file
            File.rename(xml_file, File.join(path_name, "#{item.short_name}.xml"))
            count += 1
          end
        end
      end
    rescue Down::Error, Zip::Error => e
      error_logger.log(e, item)
    end
  end
ensure
  puts "Files processed: #{count}"
  # puts "Errors encountered: #{error_logger.all_errors.count}"
end
