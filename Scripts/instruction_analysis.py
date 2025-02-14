


total_cycles = 0

rv32_major_opcode_key = [
    [0x00000073, "system"],
    [0x0000000f, "fence"],
    [0x00000033, "op"],
    [0x00000013, "op-imm"],
    [0x00000023, "store"],
    [0x00000003, "load"],
    [0x00000063, "branch"],
    [0x00000067, "jalr"],
    [0x0000006f, "jal"],
    [0x00000017, "auipc"],
    [0x00000037, "lui"],
    [0x0000002F, "amo"],
    [0x00000007, "load-fp"],
    [0x00000027, "store-fp"],
    [0x00000057, "vector"]
    ]


rv32_imm_opcode_key = [
    [0x0000]
    ]



current_inst_log = []

log = open("instlog.txt", "r")

#for every line in log
for line in log :

    total_cycles += 1

    instr = int(line, 16)
    opcode_mask = int ("0000007f", 16)
    opcode = instr & opcode_mask
    instr_identified = False
    #check to see if opcode matches
    for op_key in rv32_major_opcode_key :

        if (op_key[0] == opcode):
            # if it matches, increment counter
            instr_identified = True
            instr_added = False
            for cur in current_inst_log:
                if (cur[0] == op_key[1]):
                    instr_added = True
                    cur[1] += 1

            if (not instr_added) :
                current_inst_log.append([op_key[1], 1])


    if (not instr_identified) :
        current_inst_log.append([instr, 1])


print("Total Cycles = " + str(total_cycles) + "\n")
for instr in current_inst_log:
    print(instr)
    print("Percentage of Total = " + str(instr[1]/total_cycles * 100) + "\n")



