#! /bin/bash -x
# small RNA pipeline in the Zamore Lab
# single library mode
# 2013-05-29
# Bo W Han (bo.han@umassmed.edu)
# Phillip Zamore Lab
# RNA Therapeutics Institute
# HHMI & University of Massachusetts Medical School

###############
#configuration#
###############
case ${4} in
human)
	FOLDER=$PIPELINE_DIRECTORY/common_files/mm9/UCSC_BEDS
	declare -a TARGETS=( \
	)
;;
## mouse specific intersectBed target files
mouse)
	FOLDER=$PIPELINE_DIRECTORY/common_files/mm9/UCSC_BEDS
	
	# all annotation
	# cat repeat_mask.bed UCSC.refSeq.Exon.bed UCSC.refSeq.Intron.bed piRNA.cluster.bed6 x100910.rnaseq.transcripts.NM.all.final.bed6.c x100910.rnaseq.transcripts.NR.all.final.bed6.c | sort -k1,1 -k2,2n | bedtools merge -s -nms -i - > all.merged.bed
	MOUSE_ALL_ANNO=$FOLDER/all.merged.bed
	rtRNA=$FOLDER/repeat_mask.bed.rtRNA
	# piRNA clusters annoated in Li, et al, Mol Cell, 2013
	MOUSE_PIRNACLUSTER=$FOLDER/piRNA.cluster.bed
	MOUSE_PIRNACLUSTER_EXON=$FOLDER/piRNA.cluster.bed6
	
	MOUSE_PREPACHYTENE_PIRNA_CLUSTER=$FOLDER/piRNA.cluster.prepachytene.bed
	MOUSE_PREPACHYTENE_PIRNA_CLUSTER_EXON=$FOLDER/piRNA.cluster.prepachytene.bed6
	
	MOUSE_HYBRID_PIRNA_CLUSTER=$FOLDER/piRNA.cluster.hybrid.bed
	MOUSE_HYBRID_PIRNA_CLUSTER_EXON=$FOLDER/piRNA.cluster.hybrid.bed6
	
	MOUSE_PACHYTENE_PIRNA_CLUSTER=$FOLDER/piRNA.cluster.pachytene.bed
	MOUSE_PACHYTENE_PIRNA_CLUSTER_EXON=$FOLDER/piRNA.cluster.pachytene.bed6
	
	# NM transcripts annotated in Zamore lab, 2013
	MOUSE_ZAMORE_NM=$FOLDER/x100910.rnaseq.transcripts.NM.all.final.bed.c
	MOUSE_ZAMORE_NM_EXON=$FOLDER/x100910.rnaseq.transcripts.NM.all.final.bed6.c
	# NR transcripts annotated in Zamore lab, 2013
	MOUSE_ZAMORE_NR=$FOLDER/x100910.rnaseq.transcripts.NR.all.final.bed.c
	MOUSE_ZAMORE_NR_EXON=$FOLDER/x100910.rnaseq.transcripts.NR.all.final.bed6.c
	
	# refGene annotation in bed12 format, but only 1�6 is used
	MOUSE_refSeq_GENE=$FOLDER/UCSC.refSeq.Genes.bed
	# refGene exon annotation in bed6
	MOUSE_refSeq_EXON=$FOLDER/UCSC.refSeq.Exon.bed
	# refGene intron annotation in bed6
	MOUSE_refSeq_INTRON=$FOLDER/UCSC.refSeq.Intron.bed
	# refGene 5UTR annotation in bed6
	MOUSE_refSeq_5UTR=$FOLDER/UCSC.refSeq.5UTR.bed
	# refGene 3UTR annotation in bed6
	MOUSE_refSeq_3UTR=$FOLDER/UCSC.refSeq.3UTR.bed
	
	# repeatMasker annotation in bed6 format
	MOUSE_REPEATMASKER=$FOLDER/repeat_mask.bed
	MOUSE_REPEATMASKER_DNA=$FOLDER/repeat_mask.bed.DNA
	MOUSE_REPEATMASKER_SINE=$FOLDER/repeat_mask.bed.SINE
	MOUSE_REPEATMASKER_LINE=$FOLDER/repeat_mask.bed.LINE
	MOUSE_REPEATMASKER_LTR=$FOLDER/repeat_mask.bed.LTR
	MOUSE_REPEATMASKER_SATELLITE=$FOLDER/repeat_mask.bed.Satellite
	MOUSE_REPEATMASKER_SIMPLEREPEATS=$FOLDER/repeat_mask.bed.Simple_repeat
	MOUSE_REPEATMASKER_tRNA=$FOLDER/repeat_mask.bed.tRNA
	
	declare -a TARGETS=( \
	"MOUSE_ALL_ANNO" \
	"MOUSE_PIRNACLUSTER" \
	"MOUSE_PREPACHYTENE_PIRNA_CLUSTER" \
	"MOUSE_HYBRID_PIRNA_CLUSTER" \
	"MOUSE_PACHYTENE_PIRNA_CLUSTER" \
	"MOUSE_ZAMORE_NM" \
	"MOUSE_ZAMORE_NM_EXON" \
	"MOUSE_ZAMORE_NR" \
	"MOUSE_ZAMORE_NR_EXON" \
    "MOUSE_refSeq_GENE" \
    "MOUSE_refSeq_EXON" \
    "MOUSE_refSeq_INTRON" \
    "MOUSE_refSeq_5UTR" \
    "MOUSE_refSeq_3UTR" \
    "MOUSE_REPEATMASKER" \
    "MOUSE_REPEATMASKER_DNA" \
    "MOUSE_REPEATMASKER_SINE" \
    "MOUSE_REPEATMASKER_LINE" \
    "MOUSE_REPEATMASKER_LTR" \
    "MOUSE_REPEATMASKER_SATELLITE" \
    "MOUSE_REPEATMASKER_SIMPLEREPEATS" )
;;
mm10)
	FOLDER=$PIPELINE_DIRECTORY/common_files/mm9/UCSC_BEDS
	declare -a TARGETS=( \
	)
;;
## fly specific intersectBed target files
fly)
	FOLDER=$PIPELINE_DIRECTORY/common_files/dm3/UCSC_BEDS
	
	rtRNA=$FOLDER/repeat_mask.bed.rtRNA
	
	FLY_ALL_ANNO=$FOLDER/all.merged.bed
	FLY_PIRNA_CLUSTER=$FOLDER/Brennecke.pirnaCluster.bed 
	FLY_PIRNA_CLUSTER_42AB=$FOLDER/Brennecke.pirnaCluster.42AB.bed
	FLY_PIRNA_CLUSTER_FLAM=$FOLDER/Brennecke.pirnaCluster.flam.bed
	
	FLY_cisNATs=$FOLDER/cisNATs.bed
	FLY_STRUCTURE_LOCI=$FOLDER/structured_loci.bed
	
	FLY_flyBase_GENE=$FOLDER/UCSC.flyBase.Genes.bed
	FLY_flyBase_EXON=$FOLDER/UCSC.flyBase.Exon.bed
	FLY_flyBase_INTRON=$FOLDER/UCSC.flyBase.Intron.bed
	FLY_flyBase_INTRON_xRM=$FOLDER/UCSC.flyBase.Intron.xRM.bed
	FLY_flyBase_5UTR=$FOLDER/UCSC.flyBase.5UTR.bed
	FLY_flyBase_3UTR=$FOLDER/UCSC.flyBase.3UTR.bed
# repeatMaskser: download all-field from table browser, do :
## awk 'BEGIN{OFS="\t";getline}{print $6,$7,$8,$11,$2,$10 >> "repeat_mask.bed."$12}' UCSC.repeatMakser.dat 
## for i in repeat_mask.bed.* ; do echo "FLY_REPEATMASKER_"${i##*bed.}=\$FOLDER/$i; done
	FLY_REPEATMASKER=$FOLDER/repeat_mask.bed
	FLY_REPEATMASKER_IN_CLUSTER=$FOLDER/repeat_mask.inCluster.bed
	FLY_REPEATMASKER_OUT_CLUSTER=$FOLDER/repeat_mask.outCluster.bed
	FLY_REPEATMASKER_DNA=$FOLDER/repeat_mask.bed.DNA
	FLY_REPEATMASKER_LINE=$FOLDER/repeat_mask.bed.LINE
	#FLY_REPEATMASKER_Low_complexity=$FOLDER/repeat_mask.bed.Low_complexity
	FLY_REPEATMASKER_LTR=$FOLDER/repeat_mask.bed.LTR
	#FLY_REPEATMASKER_Other=$FOLDER/repeat_mask.bed.Other
	#FLY_REPEATMASKER_RC=$FOLDER/repeat_mask.bed.RC
	FLY_REPEATMASKER_RNA=$FOLDER/repeat_mask.bed.RNA
	FLY_REPEATMASKER_rRNA=$FOLDER/repeat_mask.bed.rRNA
	FLY_REPEATMASKER_Satellite=$FOLDER/repeat_mask.bed.Satellite
	FLY_REPEATMASKER_Simple_repeat=$FOLDER/repeat_mask.bed.Simple_repeat
	FLY_REPEATMASKER_Unknown=$FOLDER/repeat_mask.bed.Unknown
	
	FLY_TRANSPOSON_ALL=$FOLDER/transposon.bed2
	FLY_TRANSPOSON_ALL_IN_CLUSTER=$FOLDER/transposon.inCluster.bed2
	FLY_TRANSPOSON_ALL_OUT_CLUSTER=$FOLDER/transposon.outCluster.bed2
	FLY_TRANSPOSON_GROUP1=$FOLDER/Zamore.group1.bed
	FLY_TRANSPOSON_GROUP2=$FOLDER/Zamore.group2.bed
	FLY_TRANSPOSON_GROUP3=$FOLDER/Zamore.group3.bed
	FLY_TRANSPOSON_GROUP0=$FOLDER/Zamore.group0.bed
	declare -a TARGETS=( \
	"FLY_PIRNA_CLUSTER" \
	"FLY_PIRNA_CLUSTER_42AB" \
	"FLY_PIRNA_CLUSTER_FLAM" \
	"FLY_TRANSPOSON_ALL" \
	"FLY_TRANSPOSON_ALL_IN_CLUSTER" \
	"FLY_TRANSPOSON_ALL_OUT_CLUSTER" \
	"FLY_TRANSPOSON_GROUP1" \
	"FLY_TRANSPOSON_GROUP2" \
	"FLY_TRANSPOSON_GROUP3" \
	"FLY_TRANSPOSON_GROUP0" \
	"FLY_REPEATMASKER" \
	"FLY_REPEATMASKER_IN_CLUSTER" \
    "FLY_REPEATMASKER_OUT_CLUSTER" \
	"FLY_REPEATMASKER_DNA" \
	"FLY_REPEATMASKER_LINE" \
	"FLY_REPEATMASKER_LTR" \
	"FLY_cisNATs" \
	"FLY_STRUCTURE_LOCI" \
	"FLY_flyBase_GENE" \
	"FLY_flyBase_EXON" \
	"FLY_flyBase_INTRON" \
	"FLY_flyBase_INTRON_xRM" \
	"FLY_flyBase_5UTR" \
	"FLY_flyBase_3UTR" \
	"FLY_REPEATMASKER_Satellite" \
	"FLY_REPEATMASKER_Simple_repeat" \
	"FLY_REPEATMASKER_RNA" \
	"FLY_REPEATMASKER_Unknown" )
;;
*)
	echo "unknown orgnanism... currently only mouse/fly is supported"
	exit 2
;;
esac

#####################
#variable assignment#
#####################
UNIQ_BED=${1%bed2}x_rpmk_rtRNA.bed2
PURE_MULTI_BED=${2%bed2}x_rpmk_rtRNA.bed2
OUT=$3
FA=$5
[ ! -z $6 ] && CPU=$6 || CPU=8
LO_RANGE=16
HI_RANGE=50
LENGTH_RANGE=`seq ${LO_RANGE} ${HI_RANGE}`

# get rid of rRNA mappers
echo "bedtools intersect -v -wa -a $1 -b $rtRNA > ${UNIQ_BED}" > x_rpmk_rtRNA.para
echo "bedtools intersect -v -wa -a $2 -b $rtRNA > ${PURE_MULTI_BED}" >> x_rpmk_rtRNA.para
ParaFly -c x_rpmk_rtRNA.para -CPU $CPU -failed_cmds x_rpmk_rtRNA.para.failed_commands

##############
#print header#
##############
echo -ne "Sample\tTotal_Perfect_Unique_Reads\tTotal_Perfect_Unique_Species\tTotal_Perfect_Multiple_Reads\tTotal_Perfect_Multiple_Species\tTotal_Prefix_Unique_Reads\tTotal_Prefix_Unique_Species\tTotal_Prefix_Multiple_Reads\tTotal_Prefix_Multiple_Species\t" > $OUT;
for t in ${TARGETS[@]}
do \
	echo -ne "${t}_perfect_uniq_reads\t${t}_perfect_uniq_species\t${t}_prefix_uniq_reads\t${t}_prefix_uniq_species\t${t}_sense_perfect_uniq_reads\t${t}_sense_perfect_uniq_species\t${t}_sense_prefix_uniq_reads\t${t}_sense_prefix_uniq_species\t${t}_antisense_perfect_uniq_reads\t${t}_antisense_perfect_uniq_species\t${t}_antisense_prefix_uniq_reads\t${t}_antisense_prefix_uniq_species\t" >> $OUT;
	echo -ne "${t}_perfect_multi_reads\t${t}_perfect_multi_species\t${t}_prefix_multi_reads\t${t}_prefix_multi_species\t${t}_sense_perfect_multi_reads\t${t}_sense_perfect_multi_species\t${t}_sense_prefix_multi_reads\t${t}_sense_prefix_multi_species\t${t}_antisense_perfect_multi_reads\t${t}_antisense_perfect_multi_species\t${t}_antisense_prefix_multi_reads\t${t}_antisense_prefix_multi_species\t" >> $OUT;
done
echo -ne "\n" >> $OUT;

##################
#calculate counts#
##################
echo -ne "${UNIQ_BED%%.bed*}\t" >> $OUT;
TOTAL_PERFECT_UNIQ_READS=`awk '{if ($8==255) a+=$4}END{printf "%d", a}' $UNIQ_BED`
TOTAL_PERFECT_UNIQ_SPECIES=`awk '{if ($8==255) a[$7]=1}END{printf "%d", length(a)}' $UNIQ_BED`
TOTAL_PREFIX_UNIQ_READS=`awk '{if ($8!=255) a+=$4}END{printf "%d", a}' $UNIQ_BED`
TOTAL_PREFIX_UNIQ_SPECIES=`awk '{if ($8!=255) a[$7]=1}END{printf "%d", length(a)}' $UNIQ_BED`
echo -ne "$TOTAL_PERFECT_UNIQ_READS\t$TOTAL_PERFECT_UNIQ_SPECIES\t$TOTAL_PREFIX_UNIQ_READS\t$TOTAL_PREFIX_UNIQ_SPECIES\t" >> $OUT;
awk '{ if ($8==255)perfect_ct[$7]=$4; else prefix_ct[$7]=$4 }END{perfect=0; prefix=0; for (seq in perfect_ct){perfect+=perfect_ct[seq]}; for (seq in prefix_ct){prefix+=prefix_ct[seq]}; printf "%d\t%d\t%d\t%d\t", perfect, length(perfect_ct), prefix, length(prefix_ct)}' $PURE_MULTI_BED >> $OUT

##############
#intersecting#
##############
# -wa -wb uses too much space... so change back to -u -wa
parafly_file="intersect1".para && \
rm -rf $parafly_file
# processing data
for t in ${TARGETS[@]}
do \
	echo "awk '\$8 == 255' $UNIQ_BED | bedtools intersect -f 0.5 -wa -u -a - -b  ${!t} > ${UNIQ_BED%bed2}${t}.perfect.bed2 && bed2lendis ${UNIQ_BED%bed2}${t}.perfect.bed2 > ${UNIQ_BED%bed2}${t}.perfect.bed2.lendis" >> $parafly_file ; 
	echo "awk '\$8 != 255' $UNIQ_BED | bedtools intersect -f 0.5 -wa -u -a - -b  ${!t} > ${UNIQ_BED%bed2}${t}.prefix.bed2  && bed2lendis ${UNIQ_BED%bed2}${t}.prefix.bed2 > ${UNIQ_BED%bed2}${t}.prefix.bed2.lendis" >> $parafly_file ; 
	echo "awk '\$8 == 255' $PURE_MULTI_BED | bedtools intersect -f 0.5 -wa -u -a - -b  ${!t} > ${PURE_MULTI_BED%bed2}${t}.perfect.bed2 && bed2lendis ${PURE_MULTI_BED%bed2}${t}.perfect.bed2 > ${PURE_MULTI_BED%bed2}${t}.perfect.bed2.lendis" >> $parafly_file ; 
	echo "awk '\$8 != 255' $PURE_MULTI_BED | bedtools intersect -f 0.5 -wa -u -a - -b  ${!t} > ${PURE_MULTI_BED%bed2}${t}.prefix.bed2 && bed2lendis ${PURE_MULTI_BED%bed2}${t}.prefix.bed2 > ${PURE_MULTI_BED%bed2}${t}.prefix.bed2.lendis" >> $parafly_file ; 
done
# running ParaFly if no jobs has been ran (no .completed file) or it has ran but has some failed (has .failed_commands)
if [[ ! -f ${parafly_file}.completed ]] || [[ -f $parafly_file.failed_commands ]]
then
	ParaFly -c $parafly_file -CPU $CPU -failed_cmds $parafly_file.failed_commands
fi

parafly_file="intersect2".para && \
rm -rf $parafly_file
# processing data
for t in ${TARGETS[@]}
do \
	echo "bedtools intersect -f 0.5 -wa -u -a ${UNIQ_BED%bed2}${t}.perfect.bed2       -b  ${!t} -s > ${UNIQ_BED%bed2}${t}.perfect.S.bed2        && bed2lendis ${UNIQ_BED%bed2}${t}.perfect.S.bed2        > ${UNIQ_BED%bed2}${t}.perfect.S.bed2.lendis"               >> $parafly_file ;
	echo "bedtools intersect -f 0.5 -wa -u -a ${UNIQ_BED%bed2}${t}.perfect.bed2       -b  ${!t} -S > ${UNIQ_BED%bed2}${t}.perfect.AS.bed2       && bed2lendis ${UNIQ_BED%bed2}${t}.perfect.AS.bed2       > ${UNIQ_BED%bed2}${t}.perfect.AS.bed2.lendis"              >> $parafly_file ;
	echo "bedtools intersect -f 0.5 -wa -u -a ${PURE_MULTI_BED%bed2}${t}.perfect.bed2 -b  ${!t} -s > ${PURE_MULTI_BED%bed2}${t}.perfect.S.bed2  && bed2lendis ${PURE_MULTI_BED%bed2}${t}.perfect.S.bed2  > ${PURE_MULTI_BED%bed2}${t}.perfect.S.bed2.lendis"         >> $parafly_file ;
	echo "bedtools intersect -f 0.5 -wa -u -a ${PURE_MULTI_BED%bed2}${t}.perfect.bed2 -b  ${!t} -S > ${PURE_MULTI_BED%bed2}${t}.perfect.AS.bed2 && bed2lendis ${PURE_MULTI_BED%bed2}${t}.perfect.AS.bed2 > ${PURE_MULTI_BED%bed2}${t}.perfect.AS.bed2.lendis"        >> $parafly_file ;
done
# running ParaFly if no jobs has been ran (no .completed file) or it has ran but has some failed (has .failed_commands)
if [[ ! -f ${parafly_file}.completed ]] || [[ -f $parafly_file.failed_commands ]]
then
	ParaFly -c $parafly_file -CPU $CPU -failed_cmds $parafly_file.failed_commands
fi

##################
#calculate counts#
##################
for t in ${TARGETS[@]}
do \
	TOTAL_PERFECT_UNIQ_READS=`awk '{if ($8==255) a+=$4}END{printf "%d", a}' ${UNIQ_BED%bed2}${t}.perfect.bed2`
	TOTAL_PERFECT_UNIQ_SPECIES=`awk '{if ($8==255) a[$7]=1}END{printf "%d", length(a)}' ${UNIQ_BED%bed2}${t}.perfect.bed2`
	TOTAL_PREFIX_UNIQ_READS=`awk '{if ($8!=255) a+=$4}END{printf "%d", a}' ${UNIQ_BED%bed2}${t}.prefix.bed2`
	TOTAL_PREFIX_UNIQ_SPECIES=`awk '{if ($8!=255) a[$7]=1}END{printf "%d", length(a)}' ${UNIQ_BED%bed2}${t}.prefix.bed2`
	echo -ne $TOTAL_PERFECT_UNIQ_READS"\t"$TOTAL_PERFECT_UNIQ_SPECIES"\t"$TOTAL_PREFIX_UNIQ_READS"\t"$TOTAL_PREFIX_UNIQ_SPECIES"\t" >> $OUT;
	
	TOTAL_PERFECT_S_UNIQ_READS=`awk '{if ($8==255) a+=$4}END{printf "%d", a}' ${UNIQ_BED%bed2}${t}.perfect.S.bed2 `
	TOTAL_PERFECT_S_UNIQ_SPECIES=`awk '{if ($8==255) a[$7]=1}END{printf "%d", length(a)}' ${UNIQ_BED%bed2}${t}.perfect.S.bed2`
	TOTAL_PREFIX_S_UNIQ_READS=`awk '{if ($8!=255) a+=$4}END{printf "%d", a}' ${UNIQ_BED%bed2}${t}.prefix.S.bed2`
	TOTAL_PREFIX_S_UNIQ_SPECIES=`awk '{if ($8!=255) a[$7]=1}END{printf "%d", length(a)}' ${UNIQ_BED%bed2}${t}.prefix.S.bed2`
	echo -ne $TOTAL_PERFECT_S_UNIQ_READS"\t"$TOTAL_PERFECT_S_UNIQ_SPECIES"\t"$TOTAL_PREFIX_S_UNIQ_READS"\t"$TOTAL_PREFIX_S_UNIQ_SPECIES"\t" >> $OUT;
	
	TOTAL_PERFECT_AS_UNIQ_READS=`awk '{if ($8==255) a+=$4}END{printf "%d", a}' ${UNIQ_BED%bed2}${t}.perfect.AS.bed2 `
	TOTAL_PERFECT_AS_UNIQ_SPECIES=`awk '{if ($8==255) a[$7]=1}END{printf "%d", length(a)}' ${UNIQ_BED%bed2}${t}.perfect.AS.bed2`
	TOTAL_PREFIX_AS_UNIQ_READS=`awk '{if ($8!=255) a+=$4}END{printf "%d", a}' ${UNIQ_BED%bed2}${t}.prefix.AS.bed2`
	TOTAL_PREFIX_AS_UNIQ_SPECIES=`awk '{if ($8!=255) a[$7]=1}END{printf "%d", length(a)}' ${UNIQ_BED%bed2}${t}.prefix.AS.bed2`
	echo -ne $TOTAL_PERFECT_AS_UNIQ_READS"\t"$TOTAL_PERFECT_AS_UNIQ_SPECIES"\t"$TOTAL_PREFIX_AS_UNIQ_READS"\t"$TOTAL_PREFIX_AS_UNIQ_SPECIES"\t" >> $OUT;
	
	awk '{ if ($8==255)perfect_ct[$7]=$4; else prefix_ct[$7]=$4 }END{perfect=0; prefix=0; for (seq in perfect_ct){perfect+=perfect_ct[seq]}; for (seq in prefix_ct){prefix+=prefix_ct[seq]}; printf "%d\t%d\t%d\t%d\t", perfect, length(perfect_ct), prefix, length(prefix_ct)}' ${PURE_MULTI_BED%bed2}${t}.perfect.bed2    >> $OUT;
	awk '{ if ($8==255)perfect_ct[$7]=$4; else prefix_ct[$7]=$4 }END{perfect=0; prefix=0; for (seq in perfect_ct){perfect+=perfect_ct[seq]}; for (seq in prefix_ct){prefix+=prefix_ct[seq]}; printf "%d\t%d\t%d\t%d\t", perfect, length(perfect_ct), prefix, length(prefix_ct)}' ${PURE_MULTI_BED%bed2}${t}.perfect.S.bed2  >> $OUT;
	awk '{ if ($8==255)perfect_ct[$7]=$4; else prefix_ct[$7]=$4 }END{perfect=0; prefix=0; for (seq in perfect_ct){perfect+=perfect_ct[seq]}; for (seq in prefix_ct){prefix+=prefix_ct[seq]}; printf "%d\t%d\t%d\t%d\t", perfect, length(perfect_ct), prefix, length(prefix_ct)}' ${PURE_MULTI_BED%bed2}${t}.perfect.AS.bed2 >> $OUT;
	rm -rf ${UNIQ_BED%bed2}${t}.bed2  ${PURE_MULTI_BED%bed2}${t}.bed2 ;
done

################################
#draw information content graph#
################################
parafly_file="information_content".para
for t in ${TARGETS[@]}
do \
	[ -n ${UNIQ_BED%bed2}${t}.perfect.S.bed2 ] && echo "bed22weblogo.sh ${UNIQ_BED%bed2}${t}.perfect.S.bed2  $FA" >> $parafly_file
	[ -n ${UNIQ_BED%bed2}${t}.prefix.S.bed2 ]  && echo "bed22weblogo.sh ${UNIQ_BED%bed2}${t}.prefix.S.bed2 $FA"   >> $parafly_file
	[ -n ${UNIQ_BED%bed2}${t}.perfect.AS.bed2 ] && echo "bed22weblogo.sh ${UNIQ_BED%bed2}${t}.perfect.AS.bed2  $FA" >> $parafly_file
	[ -n ${UNIQ_BED%bed2}${t}.prefix.AS.bed2 ]  && echo "bed22weblogo.sh ${UNIQ_BED%bed2}${t}.prefix.AS.bed2 $FA"   >> $parafly_file
	touch ${UNIQ_BED%bed2}${t}.perfect.S.bed2 && touch ${UNIQ_BED%bed2}${t}.perfect.AS.bed2 && echo "plot_length_S_AS.sh ${UNIQ_BED%bed2}${t}.perfect.S.bed2 ${UNIQ_BED%bed2}${t}.perfect.AS.bed2" >> $parafly_file	
	touch ${UNIQ_BED%bed2}${t}.prefix.S.bed2 && touch ${UNIQ_BED%bed2}${t}.prefix.AS.bed2 && echo "plot_length_S_AS.sh ${UNIQ_BED%bed2}${t}.prefix.S.bed2 ${UNIQ_BED%bed2}${t}.prefix.AS.bed2" >> $parafly_file	
	echo "ppbed2 -a ${UNIQ_BED%bed2}${t}.perfect.S.bed2 -b ${UNIQ_BED%bed2}${t}.perfect.AS.bed2 > ${UNIQ_BED%bed2}${t}.perfect.ppbed && Rscript --slave ${PIPELINE_DIRECTORY}/bin/draw_pp.R $${UNIQ_BED%bed2}${t}.perfect.ppbed ${UNIQ_BED%bed2}${t}.perfect" >> $parafly_file
done
# running ParaFly if no jobs has been ran (no .completed file) or it has ran but has some failed (has .failed_commands)
if [[ ! -f ${parafly_file}.completed ]] || [[ -f $parafly_file.failed_commands ]]
then
	ParaFly -c $parafly_file -CPU $CPU -failed_cmds $parafly_file.failed_commands
fi

# transpose the table
ruby -lane 'BEGIN{$arr=[]}; $arr.concat([$F]); END{$arr.transpose.each{ |a| puts a.join ("\t") } }' -F"\t" $OUT > ${OUT}.t  && \
mv ${OUT}.t ${OUT} 

###########################
#print length distribution#
###########################
# print header
rm -rf ${OUT}.lendis
for i in `echo $LENGTH_RANGE`;do echo -ne $i"\t" >> ${OUT}.lendis; done
# append newline to the end of lendis
echo >> ${OUT}.lendis
echo >> ${OUT}.lendis;
echo >> ${OUT}.lendis
echo >> ${OUT}.lendis;
echo >> ${OUT}.lendis;

for t in ${TARGETS[@]}
do \
	for lendis in \
		${UNIQ_BED%bed2}${t}.perfect.bed2.lendis \
		${UNIQ_BED%bed2}${t}.perfect.S.bed2.lendis \
		${UNIQ_BED%bed2}${t}.perfect.AS.bed2.lendis \
		${UNIQ_BED%bed2}${t}.prefix.bed2.lendis \
		${UNIQ_BED%bed2}${t}.prefix.S.bed2.lendis \
		${UNIQ_BED%bed2}${t}.prefix.AS.bed2.lendis \
		${PURE_MULTI_BED%bed2}${t}.perfect.bed2.lendis \
		${PURE_MULTI_BED%bed2}${t}.perfect.S.bed2.lendis \
		${PURE_MULTI_BED%bed2}${t}.perfect.AS.bed2.lendis \
		${PURE_MULTI_BED%bed2}${t}.prefix.bed2.lendis \
		${PURE_MULTI_BED%bed2}${t}.prefix.S.bed2.lendis \
		${PURE_MULTI_BED%bed2}${t}.prefix.AS.bed2.lendis;
	do \
		echo "awk '{l[\$1]=\$2}END{for (i=$LO_RANGE;i<=$HI_RANGE;++i){printf \"%d\\n\",l[i]?l[i]:0}}' ${lendis}" | sh | ruby -lane 'BEGIN{$arr=[]}; $arr.concat([$F]); END{$arr.transpose.each{ |a| puts a.join ("\t") } }' -F"\t" >> ${OUT}.lendis && \
		echo >> ${OUT}.lendis;
	done
done

#####################
#compress everything#
#####################
paste ${OUT} ${OUT}.lendis  | awk 'BEGIN{getline;print;head=$0;nf=NF}{if (NF==nf) print}' > ${OUT}.with_lendis 
parafly_file="compress".para
for t in ${TARGETS[@]}
do \
	echo "gzip ${UNIQ_BED%bed2}${t}.perfect.bed2" >> $parafly_file
	echo "gzip ${UNIQ_BED%bed2}${t}.perfect.S.bed2" >> $parafly_file
	echo "gzip ${UNIQ_BED%bed2}${t}.perfect.AS.bed2" >> $parafly_file
	echo "gzip ${UNIQ_BED%bed2}${t}.prefix.bed2" >> $parafly_file
	echo "gzip ${UNIQ_BED%bed2}${t}.prefix.S.bed2" >> $parafly_file
	echo "gzip ${UNIQ_BED%bed2}${t}.prefix.AS.bed2" >> $parafly_file
	echo "gzip ${PURE_MULTI_BED%bed2}${t}.perfect.bed2" >> $parafly_file
	echo "gzip ${PURE_MULTI_BED%bed2}${t}.perfect.S.bed2" >> $parafly_file
	echo "gzip ${PURE_MULTI_BED%bed2}${t}.perfect.AS.bed2" >> $parafly_file
	echo "gzip ${PURE_MULTI_BED%bed2}${t}.prefix.bed2" >> $parafly_file
	echo "gzip ${PURE_MULTI_BED%bed2}${t}.prefix.S.bed2" >> $parafly_file
	echo "gzip ${PURE_MULTI_BED%bed2}${t}.prefix.AS.bed2" >> $parafly_file
done
# running ParaFly if no jobs has been ran (no .completed file) or it has ran but has some failed (has .failed_commands)
if [[ ! -f ${parafly_file}.completed ]] || [[ -f $parafly_file.failed_commands ]]
then
	ParaFly -c $parafly_file -CPU $CPU -failed_cmds $parafly_file.failed_commands
fi

###########
#join pdfs#
###########
PDF_NAMES=""
for t in ${TARGETS[@]}
do \
	[ -f ${UNIQ_BED%bed2}${t}.perfect.lendis.pdf ] && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.perfect.lendis.pdf
	[ -f ${UNIQ_BED%bed2}${t}.prefix.lendis.pdf ] && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.prefix.lendis.pdf
	[ -f ${UNIQ_BED%bed2}${t}.perfect.ping-pong.pdf ] && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.perfect.ping-pong.pdf
	[ -f ${UNIQ_BED%bed2}${t}.perfect.S.bed2.reads.5end_60.percentage.pdf ]  && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.perfect.S.bed2.reads.5end_60.percentage.pdf
	[ -f ${UNIQ_BED%bed2}${t}.prefix.S.bed2.reads.5end_60.percentage.pdf ]  && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.prefix.S.bed2.reads.5end_60.percentage.pdf
	[ -f ${UNIQ_BED%bed2}${t}.perfect.AS.bed2.reads.5end_60.percentage.pdf ] && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.perfect.AS.bed2.reads.5end_60.percentage.pdf
	[ -f ${UNIQ_BED%bed2}${t}.prefix.AS.bed2.reads.5end_60.percentage.pdf ] && PDF_NAMES=${PDF_NAMES}" "${UNIQ_BED%bed2}${t}.prefix.AS.bed2.reads.5end_60.percentage.pdf
done
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=${1}.features.pdf ${PDF_NAMES} && rm -rf $PDF_NAMES


