class PronouncablePasswordGenerator
  VOWELS = %w(a e i o u)
  CONSONANTS = ('a'..'z').to_a - VOWELS
  BIGRAMS = %w(ch sh th ph wh)
  NUMBERS = ('0'..'9').to_a
  SPECIAL_CHARS = %w(! @  $ % ^ & *)

  def initialize(options = {})
    @case_option = options[:case] || :lowercase
    @add_non_letter = options[:add_non_letter] || false
    @password_length = options[:password_length] || 12
    @non_letter_count = options[:non_letter_count] || 0
  end

  def generate 
    password = generate_pronouncable_part
    add_non_letter_chars(password) if @add_non_letter
    apply_case_options(password)
  end

  private 

  def generate_pronouncable_part
    password = ""
    length = @password_length - @non_letter_count

    while length > 0
      if length >= 3 && rand < 0.5
        password << BIGRAMS.sample
        length -= 2
      else
        password << CONSONANTS.sample
        length -= 1
      end

      if length > 0
        password << VOWELS.sample
        length -= 1
      end
    end

    password[0, @password_length]
  end

  def add_non_letter_chars(password)
    non_letter_chars = []
    @non_letter_count.times do
      non_letter_chars << (rand(2) == 0 ? NUMBERS.sample : SPECIAL_CHARS.sample)
    end

    if rand(2) == 0
      password.insert(0, non_letter_chars.join)
    else
      password << non_letter_chars.join
    end
  end

  def apply_case_options(password)
    case @case_option
      when :uppercase
        password.upcase
      when :lowercase
        password.downcase
      when :mixed
        password.chars.map { |char| rand(2) == 0 ? char.upcase : char.downcase }.join
      when :capitalize
        password.capitalize
    end
  end
end