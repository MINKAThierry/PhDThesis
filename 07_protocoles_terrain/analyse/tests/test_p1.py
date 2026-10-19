"""P1: catalogue domains, attention checks, exclusion rule, rotation lists."""

from collections import Counter
from pathlib import Path

import numpy as np
import pytest

from cro_terrain import p1
from cro_terrain.information import delta_hat
from cro_terrain.templates import read_template_text, header

ROOT = Path(__file__).resolve().parents[2]


def test_catalogue_has_50_pairs_with_thesis_split():
    assert len(p1.CATALOGUE_DOMAINS) == 50
    assert Counter(p1.CATALOGUE_DOMAINS.values()) == {1: 16, 2: 15, 3: 16, 4: 3}


@pytest.mark.parametrize("lang", ["fr", "en"])
def test_catalogue_markdown_matches_domains(lang):
    text = (ROOT / f"P1_delta/stimuli/catalogue_stimuli_{lang}.md").read_text(encoding="utf-8")
    for sid, dom in p1.CATALOGUE_DOMAINS.items():
        assert f"| {sid} | {dom} | {p1.VERDICT_SPACE[dom]} |" in text, sid


def test_attention_failures_and_exclusion():
    sid = ["ECD-C01", "HEL-C01", "G16-C01", "PSS-C07"]
    q09 = [3, 3, 2, np.nan]
    q18 = [0, 5, 1, 0]
    q28 = [1, 2, 1, 4]
    f = p1.attention_failures(q09, q18, q28, sid)
    assert f.tolist() == [0, 1, 3, 1]
    assert p1.excluded(f).tolist() == [0, 0, 1, 0]
    f2 = p1.attention_failures(q09, q18, q28, sid, missing_is_failure=False)
    assert f2.tolist() == [0, 1, 3, 0]


def test_unknown_stimulus_rejected():
    with pytest.raises(KeyError):
        p1.attention_failures([3], [0], [1], ["ECD-C11"])


def test_rotation_lists_cover_each_pair_once():
    seen = Counter()
    for r in range(1, 6):
        blocks = p1.rotation_blocks(r)
        assert sum(len(v) for v in blocks.values()) == 10
        for pair in blocks.values():
            seen.update(pair)
    assert set(seen) == set(p1.CATALOGUE_DOMAINS) and set(seen.values()) == {1}
    assert p1.rotation_blocks(2)["EGC"] == ("EGC-C01", "EGC-C02")  # table of the protocol


def test_filled_template_round_trip_and_delta_hat():
    cols = header("p1_answers", "fr")
    rng = np.random.default_rng(0)
    rows = []
    for i in range(80):
        sid = "ECD-C01"
        m = "M1" if i % 2 == 0 else "M2"
        s = f"S{1 + (i % 4)}"
        row = dict.fromkeys(cols, "")
        row.update({"id_participant": f"P1-JG-{i:03d}", "strate": "JG", "phase": "1",
                    "id_stimulus": sid, "type_preuve": "ECD", "id_contexte_c": sid,
                    "id_preuve_sigma": f"{sid}-{s}", "id_message_m": f"{sid}-{m}",
                    "rang_presentation": "1", "verdict_v": str(1 + int(rng.integers(0, 4))),
                    "q09_attention": "3", "q18_attention": "0", "q28_attention": "1",
                    "confiance_0_10": "7", "temps_s": "900"})
        for q in p1.P1_DIMENSION_ITEMS:
            row[q] = str(int(rng.integers(0, 8)))
        rows.append(row)
    text = ",".join(cols) + "\n" + "\n".join(",".join(r[c] for c in cols) for r in rows) + "\n"
    d = p1.add_computed_columns(read_template_text(text, "p1_answers"))
    assert d["_language"][0] == "fr"
    assert np.all(d["attention_failures"] == 0) and np.all(d["excluded"] == 0)
    v = p1.verdict_vector(d)
    assert len(v) == 80 and len(v[0]) == 23
    # verdicts drawn independently of sigma: Delta_hat (global verdict) close to 0
    est = delta_hat(d["verdict_v"], d["sigma_id"], d["message_id"], method="mm")
    assert est < 0.25
