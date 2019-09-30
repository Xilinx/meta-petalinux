#!/bin/bash

function usage {

	CMD=$(basename "$0")
	echo "${CMD} [-h|--help|--inbif <BIF>|--work <WORK>|--outbif <BIF>|--pdi <PDI>"
	echo "Optional:"
	echo "	-h | --help	Print usage"
	echo "	--inbif	<BIF>	Path of input BIF file. If not provided, it will
	     			generate AIE config and ELFs only paritial PDI."
	echo "	--work <WORK>	Path of AIE compiler generated Work directory"
	echo "	--outbif <BIF>	Path of output BIF file"
	echo "	--pdi <PDI>	Path of output PDI"
}

INBIF=""
OUTBIF="new-aie.bif"
WORKDIR="Work"
PDI="new-aie.pdi"
PARTIAL_PDI=

echo "$@"

options=$(getopt -o h -l help,inbif:,outbif:,work:,pdi: -- "$@")
if [ $? -ne 0 ]; then
	echo "Incorrect option provided"
	exit 1
fi
eval set -- "$options"
while true; do
	case "$1" in
	-h|--help)
		usage
		exit 0
		;;
	--inbif)
		shift; INBIF="$1";
		;;
	--outbif)
		shift; OUTBIF="$1";
		;;
	--work)
		shift; WORKDIR="$1";
		;;
	--pdi)
		shift; PDI="$1";
		;;
	--)
		shift;
		break;
	esac
	shift;
done

if [ -z "${INBIF}" ]; then
	PARTIAL_PDI=y
elif [ ! -f "${INBIF}" ] ;then
	echo "Input BIF ${INBIF} doesn't exist."
	exit 1
fi

aie_cdo=$(find "${WORKDIR}" -name "aie_cdo.bin")
if [ -z "${aie_cdo}" ]; then
	echo "AIE CDO BIN doesn't exist in ${WORKDIR}"
	exit 1
fi
aie_cdo=$(readlink -f "${aie_cdo}")

aie_elfs=$(find "${WORKDIR}" -type f -name "*[0-9]_[0-9]")
OUTFILE="aie.tmp.bif.part"
echo "  partition" > "${OUTFILE}"
echo "  {" >> "${OUTFILE}"
echo "   id = 0x10" >> "${OUTFILE}"
echo "   type = cdo" >> "${OUTFILE}"
echo "   file = ${aie_cdo}" >> "${OUTFILE}"
echo "  }" >> "${OUTFILE}"
i=0x11
for f in $(echo "${aie_elfs}"); do
	f=$(readlink -f "$f")
	i=$(printf "0x%x" $(($i + 1)))
	echo "  partition" >> "${OUTFILE}"
	echo "  {" >> "${OUTFILE}"
	echo "   id = $i" >> "${OUTFILE}"
	echo "   core = aie" >> "${OUTFILE}"
	echo "   file = ${f} " >> "${OUTFILE}"
	echo "  }" >> "${OUTFILE}"
done

if [ "${PARTIAL_PDI}" == "y" ]; then
	echo "generating new partail BIF ${OUTBIF}"
	echo "new_bif:
{
  id_code = 0x01
  id = 0x2
  image
  {" > "${OUTBIF}"
	  while IFS= read line; do
		  echo "$line"
	  done < "${OUTFILE}" >> "${OUTBIF}"
	  echo " }
}" >> "${OUTBIF}"
else
	echo "generating new BIF ${OUTBIF}"
	num_parts=$(grep -e "[[:space:]]partition" -n "${INBIF}")
	n=0
	while IFS= read -r line
	do
		echo "${line}"
		if [[ "${line}" == *"}"* ]] && [ $n -eq 9 ]; then
			tmpstr=$(cat "${OUTFILE}")
			echo "${tmpstr}"
			n=$((n + 1))
		fi
		if [[ "${line}" == *"partition"* ]]; then
			n=$((n + 1))
		fi
	done < "${INBIF}" > "${OUTBIF}"

fi

echo "generating new PDI ${PDI}"
bootgen -arch versal -image "${OUTBIF}" -w -o "${PDI}"
