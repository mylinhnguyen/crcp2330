
class Parser

  def initialize(assembly_instructions)
  	@assembly_instructions = assembly_instructions
  	@machine_instructions = []
  end

  def parse
  	@assembly_instructions.each do |instruction|
   	  if command_type(instruction) == :a_command
   	  	@machine_instructions << assemble_a_command(instruction)
   	  elsif command_type(instruction) == :c_command
   	  	@machine_instructions << assemble_c_command(instruction)
   	  end
   	end
  	@machine_instructions
  end

  def assemble_a_command(instruction)
  	command = "0"
      if instruction.end_with?("0") && !instruction.include?("1")
        command << "000000000000000"
      else
  	    command << constant(instruction[1..-1])
      end
  end

  def constant(value)
    "%015b" % value
  end

  def assemble_c_command(instruction)
  	command = "111" 
    command << comp_first_char(instruction)
    command << comp(instruction)
    command << dest(instruction)
    command << jump(instruction)
  end

  def comp_first_char(instruction)
    if instruction.include?("=")
      symbol = instruction.split("=")[1]
        if symbol.include?("M")
          "1"
        else
          "0" 
        end 
    else 
      symbol = instruction.split(";")[0]
        if symbol.include?("M")
          "1"
        else
          "0"
        end
    end 
  end
  
  def comp(instruction)
    if instruction.include?("=")
      symbol = instruction.split("=")[1]
    else
      symbol = instruction.split(";")[0]
    end
    COMP[symbol]
  end

  def dest(instruction) 
    if instruction.include?("=") 
      symbol = instruction.split("=")[0]
      DEST[symbol]
      #"DDD"
    else
      "000"
    end
  end

  def jump(instruction)
    if instruction.include?("J")
      if instruction.include?(";")
        symbol = instruction.split(";")[1]
        JUMP[symbol]
      end
    else
      "000"
    end
  end
  
  def command_type(instruction)
  	if instruction.start_with?("@") 
  	  :a_command
  	else
  	  :c_command
  	end
  end

  DEST = { 
    nil => "",
    'M' => "001",
    'D' => "010",
    'MD' => "011",
    'A' => "100",
    'AM' => "101",
    'AD' => "110",
    'AMD' => "111"
  }
  COMP = {
    '0' => "101010",
    '1' => "111111",
    '-1' => "111010",
    'D' => "001100",
    'A' => "110000",
    'M' => "110000",
    '!D' => "001101",
    '!A' => "110001",
    '!M' => "110001",
    '-D' => "001111",
    '-A' => "110011",
    '-M' => "110011",
    'D+1' => "011111",
    'A+1' => "110111",
    'M+1' => "110111",
    'D-1' => "001110",
    'A-1' => "110010",
    'M-1' => "110010",
    'D+A' => "000010",
    'D+M' => "000010",
    'D-A' => "010011",
    'D-M' => "010011",
    'A-D' => "000111",
    'M-D' => "000111",
    'D&A' => "000000",
    'D&M' => "000000",
    'D|A' => "010101",
    'D|M' => "010101"

  }
  JUMP = {
    nil => "",
    'JGT' => "001",
    'JEQ' => "010",
    'JGE' => "011",
    'JLT' => "100",
    'JNE' => "101",
    'JLE' => "110",
    'JMP' => "111"
  }
end
