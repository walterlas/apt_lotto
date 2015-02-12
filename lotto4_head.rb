# Lotto v.05 [lotto4_head.rb]
# Add in stuff for MegaMillions
# Definitions
# Max lottery number is 59, max PowerBall is 35
# Max Lottery Number is 75, max MegaBall is 15
# Location of MegaMillions.csv = http://txlottery.org/export/sites/lottery/Games/Mega_Millions/Winning_Numbers/megamillions.csv
# Location of PowerBall.csv = http://txlottery.org/export/sites/lottery/Games/Powerball/Winning_Numbers/powerball.csv

class Lottery
  @name =       ""
  @numbers =    []
  @powerball =  0 #MegaBall
  @powerplay =  0 #Megaplier
  @date =       0

  attr_reader :name, :numbers, :powerball, :powerplay, :date
  attr_writer :name, :powerplay

  def pad_numbers(number)
    if number.to_i < 10
      number = "0" + number
    end
    return(number)
  end

  def set_numbers(a,b,c,d,e)
    a = pad_numbers(a)
    b = pad_numbers(b)
    c = pad_numbers(c)
    d = pad_numbers(d)
    e = pad_numbers(e)
    @numbers = [a,b,c,d,e]
  end

  def set_powerball(pb)
    pb = pad_numbers(pb)
    @powerball = pb
  end

  def set_date(m,d,y)
    m = pad_numbers(m)
    d = pad_numbers(d)
    @date = m.to_str + "/" + d.to_str + "/" + y.to_str
  end

  def get_numbers
    copy = @numbers.sort
    nums = copy.join(" ")
    return(nums)
  end
  
  def get_pbi
    copy = @powerball.to_i
    return(copy)
  end

  def show_ticket
    print "[" + @date + "] "
    print get_numbers + " "
    puts "PB: #{@powerball}"
  end
end

# Definitions

# Load a line of winner results and store it in an array
def load_tickets(game)
  lottery_base = "http://txlottery.org/export/sites/lottery/Games/"
  megamillions = "Mega_Millions/Winning_Numbers/megamillions.csv"
  powerball = "Powerball/Winning_Numbers/powerball.csv"
  tickets = []
  if game == "mm"
    filename = "megamillions.csv"
    arg_curl = lottery_base + megamillions
  elsif game == "pb"
    filename = "powerball.csv"
    arg_curl = lottery_base + powerball
  end
  lines = []
  counter = 0
  if !File.exist?(filename)
    grab = `curl -o #{filename} #{arg_curl}`
  end
  file = File.open("powerball.csv","r")
  while !file.eof?
    lines[counter] = file.readline
    counter += 1
  end
  counter = 0
  lines.each do |line|
    tickets << Lottery.new
    work = line.split(",")
    tickets[counter].name = work[0]
    tickets[counter].set_date(work[1],work[2],work[3])
    tickets[counter].set_numbers(work[4],work[5],work[6],work[7],work[8])
    tickets[counter].set_powerball(work[9])
    tickets[counter].powerplay = work[10]
    counter += 1
  end
  return(tickets)
end

# Find matching numbers. A minimum of three numbers is needed
def find_matches(a,b)
  
  match_count = 0
  if a[0..1] == b[0..1]
    match_count += 1
  end
  if a[3..4] == b[3..4]
    match_count += 1
  end
  if a[6..7] == b[6..7]
    match_count += 1
  end
  if a[9..10] == b[9..10]
    match_count += 1
  end
  if a[12..13] == b[12..13]
    match_count += 1
  end
  return(match_count)
end
# Print the menu and return choice
def print_menu(game)
  puts "----------Main  Menu----------#{tickets.length}"
  if game == "pb"
    puts "PowerBall".center(30,' ')
  else
    puts "MegaMillions".center(30,' ')
  end
  puts "------------------------------"
  puts "01. Show Winning Number frequency"
  puts "02. Show PowerBall frequency"
  puts "03. Match your numbers to past winners!"
  puts "04. Show all numbers"
  if game == "pb"
    puts "05. Switch to MegaMillions"
  elsif game == "mm"
    puts "05. Switch to PowerBall"
  end
  puts "Q to quit"
  print "> "
  inkey = gets
  return(inkey)
end
# Get the user's numbers
def get_user_numbers
  user_numbers = []
  retval = []
  
  puts "Enter your lucky numbers!"
  for loop in 0..4
    print "Number #{loop+1}: "
    user_numbers[loop] = gets
  end
  print "Powerball:"
  user_numbers[5] = gets
  for loop in 0..5
    temp = user_numbers[loop]
    temp.strip!
    if temp.to_i < 10
      temp = "0" + temp
      user_numbers[loop] = temp
    end
  end
  retval = user_numbers.join(" ")
  return(retval)
end

def get_matches(numbers,tickets)
  counter = 0
  matches = 0
  pb_matches = 0
  temp = 0
  inner = 0
  full_matches = 0
  partial_matches = 0
  retval = []
  while counter < tickets.length
    temp = 0
    winners = tickets[counter].get_numbers
    win_pb = tickets[counter].powerball
    numbers.strip!
    temp = find_matches(numbers,winners)
    if temp >= 3
      tickets[counter].show_ticket
      if temp == 5
        full_matches += 1
      else
        partial_matches += 1
      end
      if numbers[15..16] = win_pb
        pb_matches += 1
      end
    end
    counter += 1
  end
  retval[0] = full_matches
  retval[1] = partial_matches
  retval[2] = pb_matches
  results = retval.join(" ")
  return(results)
end

def pb_frequency(tickets)
  counter = 0
  work = []
  pb_count = Array.new(37)
  pb_val = 0
  value = 0
  
  while counter < tickets.length
    pb_val = tickets[counter].get_pbi
    value = pb_count[pb_val]
    if value.nil?
      value = 0
    end
    value += 1
    pb_count[pb_val] = value
    counter +=1
  end
  retval = pb_count.join(" ")
  return(retval)
end

def number_frequency(tickets)
  counter = 0
  work = []
  work2 = []
  number_count = Array.new(60)
  num_val = 0
  while counter < tickets.length
    temp = tickets[counter].get_numbers
    work = temp.split(" ")
    for d in 0..4
      work2[d] = work[d].to_i
    end
    for c in 0..4
      if number_count[work2[c]].nil?
        number_count[work2[c]] = 0
      end
      number_count[work2[c]] += 1
    end
    counter += 1
  end
  retval = number_count.join(" ")
  return(retval)
end

def switch_game(game,tickets)
  if game == "pb"
    game = "mm"
  else
    game = "pb"
  end
  tickets.clear
  tickets = load_tickets(game)
  return(tickets)
end
