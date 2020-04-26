import csv

def parse(puzzle_file):
    """Parses a tab-delimited file of puzzles. The first line is a header line and
is ignored. The return value is a list of dictionaries with the following keys:
    name - friendly name of the puzzle
    eterna_id - puzzle identifier in eterna, if supplied. otherwise, None
    author - author of the puzzle
    secondary_structure - target secondary structure in dot-brackets notation
    """
    reader = csv.reader(puzzle_file, delimiter="\t", quotechar='"')
    rows = []
    for row in reader:
        rows.append(row)
    header = rows[0]
    column_idx = {
        "name": header.index("Puzzle Name") if "Puzzle Name" in header else None,
        "eterna_id": header.index("Eterna ID") if "Eterna ID" in header else None,
        "author": header.index("Author") if "Author" in header else None,
        "secondary_structure": header.index("Secondary Structure") if "Secondary Structure" in header else None,
    }
    return [
        {
            k: row[column_idx[k]] if column_idx[k] else None \
                for k in column_idx.keys()
        }
        for row in rows[1:]
    ]
