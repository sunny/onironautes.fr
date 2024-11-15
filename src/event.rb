require "date"
require_relative "./date_format"

class Event
  def self.config
    @config ||= YAML.load_file(
      Pathname.new(__dir__).join("config.yml"),
      permitted_classes: [Date],
    )
  end

  def self.all
    config.fetch("events").map do |event|
      new(
        at: event.fetch("at"),
        type: event.fetch("type"),
        start_at: event.fetch("start_at"),
        end_at: event.fetch("end_at"),
        image: event["image"],
        cancelled: event["cancelled"],
      )
    end
  end

  def initialize(at:, type:, start_at:, end_at:, image:, cancelled:)
    @at = at
    @start_at = start_at
    @end_at = end_at
    @type = type
    @image = image
    @cancelled = !!cancelled
  end

  attr_reader :at, :start_at, :end_at, :type, :image

  def past? = at < Date.today
  def iso_date = date_format.iso_date
  def iso_datetime = "#{iso_date}T#{start_at}:00Z"
  def day = date_format.day
  def year = date_format.year
  def time = start_at.sub(":", "h").delete_suffix("00")
  def day_of_the_week_name = date_format.day_of_the_week_name
  def month_name = date_format.month_name

  def location_url = type_config.fetch("location_url")
  def location_name = type_config.fetch("location_name")
  def location_prefix = type_config.fetch("location_prefix")
  def name = type_config.fetch("name")
  def address = type_config.fetch("address")
  def map_url = type_config.fetch("map_url")
  def calendar_name = type_config.fetch("calendar_name")

  def calendar_button_description
    "#{description}[br][br]" \
      "#{entry}[br][br]" \
      "[url]https://onironautes.fr|onironautes.fr[/url]"
  end

  def description = type_config.fetch("description")
  def entry = type_config.fetch("entry")
  def cancelled? = @cancelled

  private

  def date_format = @date_format ||= DateFormat.new(at)

  def type_config
    @type_config ||= self.class.config.fetch("types").fetch(type)
  end
end
