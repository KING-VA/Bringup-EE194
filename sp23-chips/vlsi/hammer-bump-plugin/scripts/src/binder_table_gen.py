import pandas as pd
import numpy as np

df = pd.read_excel("/Users/kevin/Documents/Berkeley/courses/tapeout/tapeout_bump_mapping.xlsx", sheet_name="Class_Mapping")
df = df.replace(np.nan,"None", regex=True)  # Replace nans with None
df = df[df["Signal Name"] != "None"]        # Exclude non-named signals
df = df.astype({"Slice Instance":'int',     # Convert to Integer
                "Bit (Pad)" : 'int',
                "drv2" : 'int',
                "drv1" : 'int',
                "drv0" : 'int',
                "enq" : 'int',
                "enabq" : 'int',
                "pd" : 'int',
                "ppen" : 'int',
                "prg_slew" : 'int',
                "pwerup_pull_en" : 'int',
                "pwerupzhl" : 'int'}) 

# print(df)





f = open("/Users/kevin/Documents/Berkeley/courses/tapeout/repos/test-sp23-chips/generators/chipyard/src/main/scala/BindingTable.scala", "w")

f.write("package chipyard\n\nimport chisel3._\n\n")

f.write("case class SignalBinderConnection( slice_type : String,  slice_inst : Int,  bit : Int, \n\tval drv2 : Bool,  drv1 : Bool,  drv0 : Bool,  enq : Bool, \n\tval enabq : Bool,  pd : Bool,  ppen : Bool,  prg_slew : Bool, \n\tval pwrup_pull_en : Bool,  pwrupzhl : Bool)\n\n")
f.write("object SigTable {\n")

f.write("\tval sigBinderTable = Map[String, SignalBinderConnection] (\n")

hdr_tmp = "\t\t{:62} {:10} {:10} {:10} {:10} {:10} {:10} {:10} {:10} {:10} {:10} {:10} {:10}".format("slice_type", 
"slice_inst", 
"bit",  
"drv2",  
"drv1",  
"drv0", 
"enq", 
"enabq", 
"pd", 
"ppen", 
"prg_slew", 
"pwrup_pull_en", 
"pwrupzhl") 
hdr_tmp = "{:30}"


tup_str = "\t\t\"{0}\" -> new SignalBinderConnection(\"{1}\",{2},{3},{4}.B,{5}.B,{6}.B,{7}.B,{8}.B,{9}.B,{10}.B,{11}.B,{12}.B,{13}.B)"
count = 0
for index, row in df.iterrows():
  f.write(tup_str.format(row["Signal Name"],row["Slice Type"], row["Slice Instance"], 
    row["Bit (Pad)"],row["drv2"],
    row["drv1"],row["drv0"],
    row["enq"],row["enabq"],
    row["pd"],row["ppen"],
    row["prg_slew"],row["pwerup_pull_en"],
    row["pwerupzhl"]))
  if(count != len(df.index)-1):
    f.write(",\n")
  count = count + 1     # Cheating



f.write(")\n}")
print("done")

