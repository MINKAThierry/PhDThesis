"""CSV templates of the protocol folders and reproducible sampling."""

from pathlib import Path

import numpy as np
import pytest

from cro_terrain.sampling import draw_sample, rank_key, seed_from_parts
from cro_terrain.templates import SCHEMAS, header, read_template, read_template_text

ROOT = Path(__file__).resolve().parents[2]
TEMPLATES = {
    "p1_answers": "P1_delta/gabarit_donnees",
    "p2_decomposition": "P2_entropie_contexte/gabarit_decomposition",
    "p2_dissimilarity": "P2_entropie_contexte/gabarit_dissimilarite",
    "p2_delphi": "P2_entropie_contexte/gabarit_delphi",
    "p3_audit": "P3_opp_helios/gabarit_audit_preuves",
    "p4_verdicts": "P4_delta_alpha/gabarit_verdicts",
    "p4_verdict_space": "P4_delta_alpha/gabarit_denombrement_verdicts",
    "p5_sessions": "P5_delta_q/gabarit_sessions_pqc",
    "p6_simulation": "P6_eta_q/gabarit_simulation",
}


@pytest.mark.parametrize("schema,stem", sorted(TEMPLATES.items()))
@pytest.mark.parametrize("lang", ["fr", "en"])
def test_template_files_match_schema(schema, stem, lang):
    path = ROOT / f"{stem}_{lang}.csv"
    assert path.exists(), path
    first = path.read_text(encoding="utf-8").splitlines()[0]
    assert first.split(",") == header(schema, lang)
    data = read_template(path, schema)
    assert data["_language"][0] == lang
    assert set(SCHEMAS[schema]) <= set(data)


def test_read_french_spreadsheet_export():
    text = ("id_session;id_trustee;id_preuve;type_preuve;id_contexte;verdict;confiance_0_10;temps_s;"
            "statut_reference;remarques\n"
            "S1;T01;B001;bulletin;ENSP;1;8;125,5;authentique;\n"
            "S1;T02;B001;bulletin;ENSP;4;6,5;;authentique;hésitation\n")
    d = read_template_text(text, "p3_audit")
    assert list(d["trustee_id"]) == ["T01", "T02"]
    assert d["confidence"][1] == pytest.approx(6.5)
    assert d["time_s"][0] == pytest.approx(125.5) and np.isnan(d["time_s"][1])


def test_read_english_header():
    cols = header("p5_sessions", "en")
    row = {c: "" for c in cols}
    row.update({"participant_id": "P001", "scheme": "ML-DSA-65", "noise_condition": "C",
                "p_noise": "0.01", "verdict": "2", "aid": "without"})
    text = ",".join(cols) + "\n" + ",".join(row[c] for c in cols) + "\n"
    d = read_template_text(text, "p5_sessions")
    assert d["_language"][0] == "en"
    assert d["p_noise"][0] == pytest.approx(0.01)
    assert d["scheme"][0] == "ML-DSA-65"


def test_wrong_header_is_rejected():
    with pytest.raises(ValueError):
        read_template_text("a,b,c\n1,2,3\n", "p3_audit")


def test_sampling_reproducible_and_documented():
    ids = [f"B{i:03d}" for i in range(1, 501)]
    seed = seed_from_parts("bulletin-board-fingerprint", "0472 9915 3308")
    s1 = draw_sample(ids, 50, seed)
    s2 = draw_sample(list(reversed(ids)), 50, seed)
    assert s1 == s2 and len(s1) == 50 and len({x for x, _ in s1}) == 50
    keys = [k for _, k in s1]
    assert keys == sorted(keys)
    # every unsampled key is larger than the largest sampled key
    sampled = {x for x, _ in s1}
    assert all(rank_key(seed, x) > keys[-1] for x in ids if x not in sampled)
    assert draw_sample(ids, 50, seed + "x") != s1


def test_sampling_errors():
    with pytest.raises(ValueError):
        draw_sample(["a", "a"], 1, "s")
    with pytest.raises(ValueError):
        draw_sample(["a"], 2, "s")
    with pytest.raises(ValueError):
        draw_sample(["a"], 1, "")
