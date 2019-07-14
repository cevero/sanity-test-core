## Sanity test core

A repository that holds an unchanged zero-riscy core in order to execute sanity tests with other cores, and verify that our changes have not broken the core.

In order to run the default test (fibonacci.bin) execute
```shell
make all wave
```

Or you could compile by yourself with the commands below. Note that -voptargs="+acc" is necessary to make the signals visible with the optimization in QuestaSim 10.7c. This argument might not be necessary in lower versions.
```shell
vlog -sv -mfcu ip/zero-riscy/include/*.sv \
               ip/zero-riscy/*.sv \
               ip/soc_components/soc_utils/*.sv \
               +incdir+ip/zero-riscy/include \
               rtl/*.sv tb/*.sv

vsim -c -voptargs="+acc" -do script/run.do tb_sanity_test_core
vsim -voptargs="+acc" -do script/wave.do tb_sanity_test_core
```