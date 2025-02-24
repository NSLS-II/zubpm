#!//home/mead/epics/pscdrv/bin/linux-x86_64/pscdemo


epicsEnvSet("TOP","/home/mead/epics/pscdrv")
epicsEnvSet("BPMDIR","$(TOP)")
epicsEnvSet("ZUBPM_DBDIR","/home/mead/rfbpm/zubpm/ioc/db")


#epicsEnvSet("CNO","40")   ## Cell Number
#epicsEnvSet("HOSTNAME","diagioc-c$(CNO)")
epicsEnvSet("IOCNAME", "lab-BI")

###
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
#epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.142.20")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "16000000")


## You may have to change psc to something else
## everywhere it appears in this file

## Register all support components
dbLoadDatabase("$(BPMDIR)/dbd/pscdemo.dbd",0,0)
pscdemo_registerRecordDeviceDriver(pdbbase) 

# BPM IP address
epicsEnvSet("ZUBPM_IP", "10.0.142.60");  #4009


## Load record instances
epicsEnvSet("ALIVELEN", "8000");   # ADC Live length
epicsEnvSet("TLIVELEN", "8000");   # ADC Live length
epicsEnvSet("ALEN",100000);        # ADC DMA Length
epicsEnvSet("TLEN", "100000");      # TbT Length
epicsEnvSet("FLEN", "100000");      # FA Length

########## use template

### PVs for first zuBPM:
dbLoadRecords("$(ZUBPM_DBDIR)/zubpm.db", "P=$(IOCNAME), NO=1, ADC_LIVE_WFM_LEN=$(ALIVELEN), ADC_WFM_LEN=$(ALEN), TBT_LIVE_WFM_LEN=$(TLIVELEN), TBT_WFM_LEN=$(TLEN), SAVG_N=100, SAVG_NSAM=100")
dbLoadRecords("$(ZUBPM_DBDIR)/SFP.db", "P=$(IOCNAME), B=1, S=0, TMP=140, VCC=164, TXB=188, TXP=212, RXP=236")
dbLoadRecords("$(ZUBPM_DBDIR)/SFP.db", "P=$(IOCNAME), B=1, S=1, TMP=144, VCC=168, TXB=192, TXP=216, RXP=240")
dbLoadRecords("$(ZUBPM_DBDIR)/SFP.db", "P=$(IOCNAME), B=1, S=2, TMP=148, VCC=172, TXB=196, TXP=220, RXP=244")
dbLoadRecords("$(ZUBPM_DBDIR)/SFP.db", "P=$(IOCNAME), B=1, S=3, TMP=152, VCC=176, TXB=200, TXP=224, RXP=248")
dbLoadRecords("$(ZUBPM_DBDIR)/SFP.db", "P=$(IOCNAME), B=1, S=4, TMP=156, VCC=180, TXB=204, TXP=228, RXP=252")
dbLoadRecords("$(ZUBPM_DBDIR)/SFP.db", "P=$(IOCNAME), B=1, S=5, TMP=160, VCC=184, TXB=208, TXP=232, RXP=256")
dbLoadRecords("$(ZUBPM_DBDIR)/SA.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("$(ZUBPM_DBDIR)/Power.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("$(ZUBPM_DBDIR)/Temp.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("$(ZUBPM_DBDIR)/Live.db", "P=$(IOCNAME), NO=1, ALIVE=$(ALIVELEN), TLIVE=$(TLIVELEN)")
dbLoadRecords("$(ZUBPM_DBDIR)/FA.db", "P=$(IOCNAME), NO=1, FA_LEN=$(FLEN)")
dbLoadRecords("$(ZUBPM_DBDIR)/TBT.db", "P=$(IOCNAME), NO=1, TBT_LEN=$(TLEN)")
dbLoadRecords("$(ZUBPM_DBDIR)/ADC.db", "P=$(IOCNAME), NO=1, ADC_LEN=$(ALEN)")
### FFT PVs :
dbLoadRecords("$(ZUBPM_DBDIR)/FFT.db", "P=$(IOCNAME), NO=1")

#####################################################
var(PSCDebug, 1)  #5 full debug

#bpm1 Create the PSC
createPSC("aie_tx_1", $(ZUBPM_IP), 7, 0)
createPSC("aie_wfm_rx_1", $(ZUBPM_IP), 20, 1)
createPSC("Rx1", $(ZUBPM_IP), 600, 1)

#createPSC("aie_tx_1", $(ZUBPM_IP), 90000, 0)
#createPSC("aie_wfm_rx_1", $(ZUBPM_IP), 90001, 1)
#createPSC("Rx1", $(ZUBPM_IP), 90002, 1)



#system("./caClient/bin/linux-x86_64/bin/zuLive > ./caClients.log 2>&1 &")



###########
iocInit
###########

#epicsThreadSleep 1

dbpf $(IOCNAME){BPM:1}DMA:ADCLen-SP 10000
dbpf $(IOCNAME){BPM:1}DMA:TBTLen-SP 10000
dbpf $(IOCNAME){BPM:1}DMA:FALen-SP 5000
dbpf $(IOCNAME){BPM:1}Pos:Kx-SP $(Kx)
dbpf $(IOCNAME){BPM:1}Pos:Ky-SP $(Ky)
dbpf $(IOCNAME){BPM:1}ADC:WfmLen-SP 620
dbpf $(IOCNAME){BPM:1}ADC:WfmOff-SP 0
dbpf $(IOCNAME){BPM:1}TBT:WfmLen-SP 5000
dbpf $(IOCNAME){BPM:1}TBT:WfmOff-SP 0
dbpf $(IOCNAME){BPM:1}Live:ADC:WfmLen-SP 620
dbpf $(IOCNAME){BPM:1}Live:ADC:WfmOff-SP 0
dbpf $(IOCNAME){BPM:1}Live:TBT:WfmLen-SP 5000
dbpf $(IOCNAME){BPM:1}Live:TBT:WfmOff-SP 0
dbpf $(IOCNAME){BPM:1}FA:WfmLen-SP 5000
dbpf $(IOCNAME){BPM:1}FA:WfmOff-SP 0
dbpf $(IOCNAME){BPM:1}Trig:TrigSrc-SP 0
dbpf $(IOCNAME){BPM:1}CLK:EventSrc-SP 0
dbpf $(IOCNAME){BPM:1}Gain:RfAtte-SP, 0

dbpf $(IOCNAME){BPM:1}Gain:Adc0-SP, 32767
dbpf $(IOCNAME){BPM:1}Gain:Adc1-SP, 32767
dbpf $(IOCNAME){BPM:1}Gain:Adc2-SP, 32767
dbpf $(IOCNAME){BPM:1}Gain:Adc3-SP, 32767

#system("Starting caClients")
#system("/home/mead/rfbpm/zubpm/ioc/caClient/bin/linux-x86_64/zuLive > ./caClients.log 2>&1 &")
#system("procServ --logfile=./caClients.log  --name=zuTBT 8021 /home/mead/rfbpm/zubpm/ioc/caClient/bin/linux-x86_64/zuTBT &")


