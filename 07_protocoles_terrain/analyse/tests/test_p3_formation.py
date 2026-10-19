"""P3: the six training ballots verify as stated in the answer key."""

import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "P3_opp_helios" / "formation" / "generer_bulletins_exercice.py"

EXPECTED = {
    "EX-1": ([True, True], True), "EX-2": ([True, True], True), "EX-3": ([False, True], True),
    "EX-4": ([True, True], False), "EX-5": ([False, True], False), "EX-6": ([True, True], True),
}


def _load():
    spec = importlib.util.spec_from_file_location("p3_formation", SCRIPT)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_committed_json_matches_answer_key():
    data = json.loads((SCRIPT.parent / "bulletins_exercice.json").read_text(encoding="utf-8"))
    for k, (ok01, oksum) in EXPECTED.items():
        v = data["bulletins"][k]["verification"]
        assert v["preuves_0_1"] == ok01 and v["preuve_somme_1"] == oksum, k
    fp = {k: v["empreinte_sha256"] for k, v in data["bulletins"].items()}
    assert fp["EX-6"] == fp["EX-1"] and len(set(fp.values())) == 5


def test_verification_recomputed_from_json():
    mod = _load()
    data = json.loads(mod.OUT.read_text(encoding="utf-8"))
    y = int(data["cle_publique_scrutin"], 16)
    for k, expected in EXPECTED.items():
        ballot = mod.unhex(data["bulletins"][k]["valeurs"])
        assert mod.verify(y, ballot) == expected, k
