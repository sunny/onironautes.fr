class DateFormat
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

  def initialize(date)
    @date = date
  end

  def iso_date = date.strftime("%F")
  def day = date.strftime("%-d")
  def year = date.strftime("%Y")
  def day_of_the_week_name = WEEKDAY_NAMES.fetch(date.wday)
  def month_name = MONTH_NAMES.fetch(date.month)

  private

  attr_reader :date
end
