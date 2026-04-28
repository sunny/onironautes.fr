require "uri"
require "date"
require "yaml"
require "pathname"
require "public_suffix"
require_relative "./date_format"
require_relative "./image"

class Event
  def self.config
    @config ||= YAML.load_file(
      Pathname.new(__dir__).join("config.yml"),
      permitted_classes: [Date],
    )
  end

  def self.all
    config.fetch("events").map do |event|
      new(**event.to_h { |k, v| [k.to_sym, v]})
    end
  end

  def initialize(
    at:,
    type:,
    venue:,
    start_at:,
    end_at:,
    image_path: nil,
    base_image_path: nil,
    image_title: nil,
    image_alt: nil,
    url: nil,
    booking_url: nil,
    cancelled: nil
  )
    @at = at
    @start_at = start_at
    @end_at = end_at
    @type = type
    @venue = venue
    @image_path = image_path
    @base_image_path = base_image_path
    @image_title = image_title
    @image_alt = image_alt
    @url = url
    @booking_url = booking_url
    @cancelled = !!cancelled
  end

  attr_reader :at, :type, :venue, :start_at, :end_at, :url, :booking_url

  def image = Image.new(event: self)

  def past? = at < Date.today
  def iso_date = date_format.iso_date
  def iso_datetime = "#{iso_date}T#{start_at}:00Z"
  def day = date_format.day
  def year = date_format.year
  def time = start_at.sub(":", "h").delete_suffix("00")
  def day_of_the_week_name = date_format.day_of_the_week_name
  def month_name = date_format.month_name

  def name = type_config.fetch("name")
  def calendar_name = type_config.fetch("calendar_name")
  def description = type_config.fetch("description")

  def image_path = @image_path || venue_config["image_path"]
  def base_image_path = @base_image_path || venue_config["base_image_path"]
  def image_title = @image_title || venue_config["image_title"]
  def image_alt = @image_alt || venue_config["image_alt"]
  def location_url = venue_config.fetch("location_url")
  def location_name = venue_config.fetch("location_name")
  def location_prefix = venue_config.fetch("location_prefix")
  def address = venue_config.fetch("address")
  def map_url = venue_config.fetch("map_url")
  def entry = venue_config.fetch("entry")
  def url_domain = domain(url)
  def booking_url_domain = domain(booking_url)

  def calendar_button_description
    "#{description}[br][br]" \
      "#{entry}[br][br]" \
      "[url]https://onironautes.fr|onironautes.fr[/url]"
  end

  def cancelled? = @cancelled

  private

  def date_format = @date_format ||= DateFormat.new(at)

  def type_config
    @type_config ||= self.class.config.fetch("types").fetch(type)
  end

  def venue_config
    @venue_config ||= self.class.config.fetch("venues").fetch(venue)
  end

  def domain(url) = PublicSuffix.parse(URI.parse(url).host).domain
end
