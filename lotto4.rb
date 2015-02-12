# Lotto 4
require_relative("lotto4_head")
current_game = "pb"
tickets = []
tickets = load_tickets(current_game)
puts "Loaded #{tickets.length} records."

def show_powerball(tickets)
  temp = pb_frequency(tickets)
  pb_count = temp.split(" ")
  max = pb_count.length
  loop = 0
  puts "BonusBall Frequency Chart"
  begin
    printf "%2d = %2d \t",loop+1,pb_count[loop]
    if (loop != 0) && (loop % 4 == 0)
      print "\n"
    end
    loop += 1
  end until loop > max-1
  print "\n"
#  begin
#    printf "%2d = %2d \t %2d = %2d \t %2d = %2d\n", loop+1, pb_count[loop],
#                                                    loop+2, pb_count[loop+1],
#                                                    loop+3, pb_count[loop+2]
#    loop += 3
#  end until loop >=37
end

#def show_numbers(tickets)
#  temp = number_frequency(tickets)
#  num_count = temp.split(" ")
#  for c in 0..59
#    if num_count[c].nil?
#      num_count[c] = 0
#    end
#  end
#  loop = 0
#  puts "Number Frequency Chart"
#  begin
#    printf "%2d = %2d \t %2d = %2d \t %2d = %2d \t %2d = %2d\n", loop+1,num_count[loop],
#                                                               loop+2,num_count[loop+1],
#                                                               loop+3,num_count[loop+2],
#                                                               loop+4,num_count[loop+3]
#    loop += 4
#  end until loop > 53
#  printf "%2d = %2d \t %2d = %2d \t %2d = %2d\n",loop+1,num_count[loop],
#                                                 loop+2,num_count[loop+1],
#                                                 loop+3,num_count[loop+2]
#end

def show_numbers(tickets)
  temp = number_frequency(tickets)
  num_count = temp.split(" ")
  max = num_count.length
  for c in 0..max
    if num_count[c].nil?
      num_count[c] = 0
    end
  end
  loop = 0
  puts "Number Frequency Chart"
  begin
    printf "%2d = %2d \t",loop+1,num_count[loop]
    if loop != 0 && loop % 4 == 0
      print "\n"
    end
    loop += 1
  end until loop > (max - 1)
  print "\n"
end

def show_all(tickets)
  pager = 0
  max = tickets.length
  counter = 0
  begin
    tickets[counter].show_ticket
    pager += 1
    counter += 1
    if pager == 20
      print "Hit Enter #{counter} of #{max}"
      x = gets
      pager = 0
    end
    if x == 'Q'
      return
    end
  end until counter >= max
end

def start_matching(winners)
  work = []
  num_matches = []
  user_numbers = []
  user_numbers = get_user_numbers
  num_matches = get_matches(user_numbers,winners)
  work = num_matches.split(" ")
  print "There were #{work[0]} full matches and #{work[1]} partial matches with #{work[2]} Powerballs\n"
end

loop {
  choice = print_menu(current_game)
  choice.strip!
#  if choice == '1'
#    show_numbers(tickets)
#  elsif choice == '2'
#    show_powerball(tickets)
#  elsif choice == '3'
#    start_matching(tickets)
#  elsif choice == '4'
#    show_all(tickets)
#  elsif choice == '5'
#    current_game = switch_game(current_game)
#    tickets.clear
#    tickets = load_tickets(current_game)
#  elsif choice == 'Q' || choice == 'q'
#    break
#  else
#    puts "#{choice} is invalid."
#  end
  case choice
  when '1'
    show_numbers(tickets)
  when '2'
    show_powerball(tickets)
  when '3'
    start_matching(tickets)
  when '4'
    show_all(tickets)
  when '5'
    current_game,tickets = switch_game(current_game,tickets)
  when 'Q', 'q'
    break
  else
    puts "#{choice} is invalid"
  end
}
