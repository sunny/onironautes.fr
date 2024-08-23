require "date"

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
      )
    end
  end

  MONTH_NAMES = {
    1 => "janvier",
    2 => "février",
    3 => "mars",
    4 => "avril",
    5 => "mai",
    6 => "juin",
    7 => "juillet",
    8 => "août",
    9 => "septembre",
    10 => "octobre",
    11 => "novembre",
    12 => "décembre",
  }

  WEEKDAY_NAMES = {
    0 => "dimanche",
    1 => "lundi",
    2 => "mardi",
    3 => "mercredi",
    4 => "jeudi",
    5 => "vendredi",
    6 => "samedi",
  }

  def initialize(at:, type:, start_at:, end_at:)
    @at = at
    @start_at = start_at
    @end_at = end_at
    @type = type
  end

  attr_reader :at, :start_at, :end_at, :type

  def iso_date = at.strftime("%Y-%M-%D")
  def iso_datetime = at.strftime("%Y-%M-%DT%h:%m%:00Z")
  def day = at.strftime("%-d")
  def year = at.strftime("%Y")
  def time = start_at.sub(":", "h").delete_suffix("00")
  def day_of_the_week_name = WEEKDAY_NAMES.fetch(at.wday)
  def month_name = MONTH_NAMES.fetch(at.month)

  def location_url = type_config.fetch("location_url")
  def location_name = type_config.fetch("location_name")
  def location_prefix = type_config.fetch("location_prefix")
  def name = type_config.fetch("name")
  def address = type_config.fetch("address")
  def map_url = type_config.fetch("map_url")
  def calendar_name = type_config.fetch("calendar_name")
  def description = type_config.fetch("description")
  def entry = type_config.fetch("entry")

  private

  def type_config
    @type_config ||= self.class.config.fetch("types").fetch(type)
  end
end
