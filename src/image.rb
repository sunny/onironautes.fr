class Image
  def initialize(event:)
    @event = event
  end

  attr_reader :event

  def path
    if File.exist?(generated_path)
      generated_path
    elsif File.exist?(event.image_path)
      event.image_path
    end
  end

  def large_path
    generated_large_path if File.exist?(generated_large_path)
  end

  def generate!(base_path:)
    FileUtils.rm_rf(generated_path)

    cmd "magick #{base_path} " \
        "-resize 1000x1000 " \
        "-font Avenir-Black " \
        "-pointsize 100 " \
        "-kerning 16 " \
        "-channel RGBA " \
        "-fill \"#00000088\" " \
        "-draw \"text 293,700 \'#{event.image_title}\'\" " \
        "-draw \"text 297,697 \'#{event.image_title}\'\" " \
        "-fill \"#fffc00\" " \
        "-draw \"text 290,703 \'#{event.image_title}\'\" " \
        "-kerning 0 " \
        "-font Avenir-Roman " \
        "-fill \"#00000088\" " \
        "-draw \"text 253,830 \'#{formatted_date}\'\" " \
        "-draw \"text 247,827 \'#{formatted_date}\'\" " \
        "-fill \"#fffc00\" " \
        "-draw \"text 250,833 \'#{formatted_date}\'\" " \
        "#{generated_path}"

    FileUtils.rm_rf(generated_large_path)

    background = `magick #{generated_path} -format "%[pixel:p{0,0}]" info:-`

    cmd "magick images/base/large-mask.png " \
        "-background '#{background}' " \
        "-flatten " \
        "#{generated_large_path}"
    cmd "magick " \
        "composite " \
        "-geometry 1800x+950+0 " \
        "#{generated_path} " \
        "#{generated_large_path} " \
        "#{generated_large_path}"
  end

  def formatted_date = event.at.strftime("%d.%m.%Y")
  def generated_path = "images/events/#{event.type}-#{event.at}.jpg"
  def generated_large_path = "images/events/#{event.type}-#{event.at}-large.jpg"

  def cmd(command)
    puts command
    system command
  end
end
