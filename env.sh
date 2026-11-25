# Source from bash to enable the two-stage method's Python packages.
LEANHARDWARE_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export PYTHONPATH="$LEANHARDWARE_ROOT/method/stage1:$LEANHARDWARE_ROOT/method/stage2:$LEANHARDWARE_ROOT/method/stage2/refinement:$LEANHARDWARE_ROOT${PYTHONPATH:+:$PYTHONPATH}"
