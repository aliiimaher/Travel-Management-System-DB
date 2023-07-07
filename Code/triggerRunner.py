def executeTriggersFromFile(fileName, cur):
    # Open and read the file as a single buffer
    fd = open(fileName, 'r')
    sqlFile = fd.read()
    fd.close()

    # all SQL commands (split on '--')
    sqlCommands = sqlFile.split('--')
    del sqlCommands[len(sqlCommands)-1]

    # Execute every command from the input file
    for command in sqlCommands:
    #     # This will skip and report errors
    #     # For example, if the tables do not yet exist, this will skip over
    #     # the DROP TABLE commands
        cur.execute(command)
    # return sqlCommands