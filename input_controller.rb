require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    gb = GameBoard.new 10, 10
    ships = 0

    read_file_lines(path) {|line|
        if line =~ /^\(\d+,\d+\), (Right|Left|Up|Down), \d+$/
            values = line.split(", ")
            orient = values[1]
            size = values[2].to_i
            coordinates = values[0].split(",")
            
            part_one = coordinates[0].split("(")
            x = part_one[1].to_i
            part_two = coordinates[1].split(")")
            y = part_two[0].to_i

            loc = Position.new(x,y)
            add_this = Ship.new(loc, orient, size)

            if ships != 5
                success = gb.add_ship(add_this)
                if success
                    ships += 1
                end
            end
        end
    }

    if ships == 5
        return gb
    end

    return nil
end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    locs = []
    read_file_lines(path) {|line|
        if line =~ /^\(\d+,\d+\)$/
            coordinates = line.split(",")
            
            part_one = coordinates[0].split("(")
            x = part_one[1].to_i
            part_two = coordinates[1].split(")")
            y = part_two[0].to_i

            locs.push(Position.new(x,y))
        end
    }
    return locs
end

# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end