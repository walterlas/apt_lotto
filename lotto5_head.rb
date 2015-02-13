# Lotto v.05 [lotto4_head.rb]
# Add in stuff for MegaMillions
# Definitions
# Max lottery number is 59, max PowerBall is 35
# Max Lottery Number is 75, max MegaBall is 15
# Location of MegaMillions.csv = http://txlottery.org/export/sites/lottery/Games/Mega_Millions/Winning_Numbers/megamillions.csv
# Location of PowerBall.csv = http://txlottery.org/export/sites/lottery/Games/Powerball/Winning_Numbers/powerball.csv

class Lottery
  def initialize(name,date,numbers,bonusball,multiplier)
    @name = name
    @numbers = numbers
    @bonusball = bonusball
    @multiplier = multiplier
    @date = date
    attr_reader :name, :numbers, :bonusball, :multiplier, :date
  end
  
  def show_ticket
    print "[" + @date + "]"
    print @name + " "
    print show_numbers + " "
    if @name == "Powerball"
      print "PB:" + @bonusball + " Powerplay:" + @multiplier + "\n"
    else
      print "MB:" + @bonusball + " Megaplier:" + @multiplier + "\n"
    end    
  end
  
  def show_numbers
    return(@numbers.join(" "))
  end
end

def pad_number(number)
  if number.to_i < 10
    number = "0" + number
  end
  return(number)
end

def load_tickets
  lottery_base = "http://txlottery.org/export/sites/lottery/Games/"
  megamillions = "Mega_Millions/Winning_Numbers/megamillions.csv"
  powerball    = "Powerball/Winning_Numbers/powerball.csv"
  powerfile = "powerball.csv"
  megafile = "megamillions.csv"
  tickets = []
  lines = []
  counter = 0
  power_start = 0
  power_end   = 0
  mega_start  = 0
  mega_end    = 0
  if !File.exist?(powerball) # download powerball.csv if missing
    grab = `curl -o #{powerfile} #{lottery_base + powerball}`
  end
  if !File.exist?(megafile) # download megamillions.csv if missing
    grab = `curl -o #{megafile} #{lottery_base + megamillions}`
  end
  file_handle = File.open(powerfile,"r") # read in Powerball file first
  while !file_handle.eof?
    lines[counter] = file_handle.readline
    counter += 1
  end
  power_end = counter - 1
  mega_start = counter
  file_handle.close
  file_handle = File.open(megafile,"r") # read in MegaMillions file now
  while !file_handle.eof?
    lines[counter] = file_handle.readline
    counter += 1
  end
  mega_end = counter - 1
  counter = 0
  lines.each do |line|
    work = line.split(",")
    name = work[0]
    date = pad_number(work[1]) + "/" + pad_number(work[2]) + "/" + work[3]
    for loop in 4..8
      temp[loop] = work[loop]
    end
    numbers = temp.join(" ")
    bonusball = work[9]
    multiplier = work[10]
    tickets << Lottery.new(name,date,numbers,bonusball,multiplier)
  end
  return(tickets)  
end

def find_matches(a,b)
  user = a.split(" ")
  system = b.split(" ")
  matches = 0
  for loop in 0..4
    if b.include?(user[loop])
      matches += 1
    end
  end
  return(matches)
end

def print_menu(game)
  display_name = ""
  print "-" * 10
  print "Main  Menu"
  print "-" * 10
  if game == "pb"
    puts "PowerBall".center(30,' ')
    display_name = "Powerball"
  else
    puts "MegaMillions".center(30,' ')
    display_name = "MegaBall"
  end
  puts "-" * 30
  puts "01. Show Winning Number Frequency"
  puts "02. Show #{display_name} Frequency"
  puts "03. Match your numbers to past winners"
  puts "04. Show all winning tickets"
  if game == "pb"
    puts "05. Switch to MegaMillions"
  else
    puts "05. Switch to PowerBall"
  end
  puts "Q to quit"
  print "> "
  inkey = gets.chomp
  return(inkey)
end

def get_user_numbers(game)
  user_numbers[]
  retval = []
  if game == "pb"
    bonusball = "PowerBall"
  else
    bonusball = "MegaBall"
  end
  puts "Enter your lucky numbers!"
  for loop in 0..4
    print "Number #{loop+1}: "
    user_numbers[loop] = gets.chomp
  end
  print "#{bonusball}: "
  user_numbers[5] = gets.chomp
  for loop in 0..5
    user_numbers[loop] = pad_number(user_numbers[loop])
  end
  retval = user_numbers.join(" ")
  return(retval)
end

def get_matches(numbers,tickets)
  counter = 0
  matches = 0
  bb_matches = 0
  full_matches = 0
  partial_matches = 0
  start,finish = get_range(game)
  for loop in start..finish
    temp = 0
    winners = tickets[loop].get_numbers
    win_bb  = tickets[loop].bonusball
    temp    = find_matches(numbers,winners)
    if temp >= 3
      tickets[loop].show_ticket
      if temp == 5
        full_matches += 1
      else
        partial_matches += 1
      end
      if numbers[5] == win_bb
        bb_matches += 1
      end
    end
  end
  retval[0] = full_matches
  retval[1] = partial_matches
  retval[2] = bb_matches
  results = retval.join(" ")
  return(results)
end
