ARGV=`getopt -o p:q:o: --long pep1:,pep2:,out: -- "$@"`
eval set -- "$ARGV"
## passing the parameters
while true;do
	case "$1" in 
		-p|--pep1)
		Gpro1=$2;shift 2;;
		-q|--pep2)
		Gpro2=$2;shift 2;;
		-o|--out)
		Output_dir=$2;shift 2;;
		--)
		shift;break;;
		*)echo err;exit 1;
	esac
done

mkdir $Output_dir/Result $Output_dir/index
cp $Gpro1 $Output_dir/index
Gpro1=${Gpro1##*/}
Gpro1=$Output_dir/index/$Gpro1
cp $Gpro2 $Output_dir/index
Gpro2=${Gpro2##*/}
Gpro2=$Output_dir/index/$Gpro2

script=`pwd`
## Indexing proteins of each genome
makeblastdb -input_type fasta -dbtype prot -in $Gpro1
makeblastdb -input_type fasta -dbtype prot -in $Gpro2
## Calculating the length of each protein
perl $script/length.pl $Gpro1 >${Gpro1}.length
perl $script/length.pl $Gpro2 >${Gpro2}.length
## Comparing proteins of the two genomes
blastp -outfmt 6 -num_threads 1 -task blastp -evalue 1e-5 -db $Gpro2 -query $Gpro1 -out $Output_dir/Result/1-2.blast
blastp -outfmt 6 -num_threads 1 -task blastp -evalue 1e-5 -db $Gpro1 -query $Gpro2 -out $Output_dir/Result/2-1.blast
## Calculating the percentage of conserved proteins index
perl $script/POCP.pl --fpro ${Gpro1}.length --spro ${Gpro2}.length --fbla $Output_dir/Result/1-2.blast --sbla $Output_dir/Result/2-1.blast --res $Output_dir/Result/POCP_result.txt
