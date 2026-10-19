"""Reading the CSV templates produced by the field protocols.

Each template exists in a French and an English version (headers translated).
``read_template`` detects the language from the header, maps the columns to
canonical English names, converts numeric columns (accepting a decimal comma
and the ';' separator used by spreadsheets in French locale) and returns a
dict of column name -> numpy array.

Canonical schemas
-----------------
p1_answers   : P1_delta/gabarit_donnees_{fr,en}.csv
p2_decomposition : P2_entropie_contexte/gabarit_decomposition_{fr,en}.csv
p2_dissimilarity : P2_entropie_contexte/gabarit_dissimilarite_{fr,en}.csv
p2_delphi    : P2_entropie_contexte/gabarit_delphi_{fr,en}.csv
p3_audit     : P3_opp_helios/gabarit_audit_preuves_{fr,en}.csv
p4_verdicts  : P4_delta_alpha/gabarit_verdicts_{fr,en}.csv
p4_verdict_space : P4_delta_alpha/gabarit_denombrement_verdicts_{fr,en}.csv
p5_sessions  : P5_delta_q/gabarit_sessions_pqc_{fr,en}.csv
p6_simulation: P6_eta_q/gabarit_simulation_{fr,en}.csv
"""

from __future__ import annotations

import csv
import io as _io
from pathlib import Path
from typing import Mapping

import numpy as np

# canonical name: (french header, english header)
SCHEMAS: dict[str, dict[str, tuple[str, str]]] = {
    "p1_answers": {
        "participant_id": ("id_participant", "participant_id"),
        "stratum": ("strate", "stratum"),
        "phase": ("phase", "phase"),
        "session_id": ("id_session", "session_id"),
        "interviewer_id": ("id_enqueteur", "interviewer_id"),
        "stimulus_id": ("id_stimulus", "stimulus_id"),
        "proof_type": ("type_preuve", "proof_type"),
        "context_id": ("id_contexte_c", "context_c_id"),
        "sigma_id": ("id_preuve_sigma", "proof_sigma_id"),
        "message_id": ("id_message_m", "message_m_id"),
        "presentation_rank": ("rang_presentation", "presentation_rank"),
        "verdict_v": ("verdict_v", "verdict_v"),
        "q02": ("q02", "q02"),
        "q03": ("q03", "q03"),
        "q04": ("q04", "q04"),
        "q05": ("q05", "q05"),
        "q06": ("q06", "q06"),
        "q07": ("q07", "q07"),
        "q08": ("q08", "q08"),
        "q09_attention": ("q09_attention", "q09_attention"),
        "q10": ("q10", "q10"),
        "q11": ("q11", "q11"),
        "q12": ("q12", "q12"),
        "q13": ("q13", "q13"),
        "q14": ("q14", "q14"),
        "q15": ("q15", "q15"),
        "q16": ("q16", "q16"),
        "q17": ("q17", "q17"),
        "q18_attention": ("q18_attention", "q18_attention"),
        "q19": ("q19", "q19"),
        "q20": ("q20", "q20"),
        "q21": ("q21", "q21"),
        "q22": ("q22", "q22"),
        "q23": ("q23", "q23"),
        "q24": ("q24", "q24"),
        "q25": ("q25", "q25"),
        "confidence": ("confiance_0_10", "confidence_0_10"),
        "q27_proof_contribution": ("q27_apport_preuve", "q27_proof_contribution"),
        "q28_attention": ("q28_attention", "q28_attention"),
        "q29_expertise": ("q29_expertise", "q29_expertise"),
        "q30_elements": ("q30_elements", "q30_elements"),
        "time_s": ("temps_s", "time_s"),
        "attention_failures": ("echecs_attention", "attention_failures"),
        "excluded": ("exclu", "excluded"),
        "deviation_id": ("id_ecart", "deviation_id"),
    },
    "p2_decomposition": {
        "expert_id": ("id_expert", "expert_id"),
        "domain": ("domaine", "domain"),
        "component": ("composante", "component"),
        "element": ("element", "element"),
        "n_categories": ("nb_modalites", "n_categories"),
        "entropy_bits": ("entropie_bits", "entropy_bits"),
        "notes": ("remarques", "notes"),
    },
    "p2_dissimilarity": {
        "expert_id": ("id_expert", "expert_id"),
        "session_id": ("id_session", "session_id"),
        "domain": ("domaine", "domain"),
        "ctx_i": ("id_ctx_i", "ctx_i_id"),
        "ctx_j": ("id_ctx_j", "ctx_j_id"),
        "presentation_rank": ("rang_presentation", "presentation_rank"),
        "dissimilarity": ("dissimilarite_0_10", "dissimilarity_0_10"),
        "notes": ("remarques", "notes"),
    },
    "p2_delphi": {
        "expert_id": ("id_expert", "expert_id"),
        "round": ("tour", "round"),
        "domain": ("domaine", "domain"),
        "h_estimate": ("h_estimee_bits", "h_estimate_bits"),
        "lower_bound": ("borne_basse_bits", "lower_bound_bits"),
        "upper_bound": ("borne_haute_bits", "upper_bound_bits"),
        "confidence": ("confiance_0_10", "confidence_0_10"),
        "argument": ("argument", "argument"),
        "notes": ("remarques", "notes"),
    },
    "p3_audit": {
        "session_id": ("id_session", "session_id"),
        "trustee_id": ("id_trustee", "trustee_id"),
        "proof_id": ("id_preuve", "proof_id"),
        "proof_type": ("type_preuve", "proof_type"),
        "context_id": ("id_contexte", "context_id"),
        "verdict": ("verdict", "verdict"),
        "confidence": ("confiance_0_10", "confidence_0_10"),
        "time_s": ("temps_s", "time_s"),
        "reference_status": ("statut_reference", "reference_status"),
        "notes": ("remarques", "notes"),
    },
    "p4_verdicts": {
        "participant_id": ("id_participant", "participant_id"),
        "stratum": ("strate", "stratum"),
        "institution_type": ("type_institution", "institution_type"),
        "context_id": ("id_contexte", "context_id"),
        "proof_id": ("id_preuve", "proof_id"),
        "sigma_code": ("code_sigma", "sigma_code"),
        "proof_type": ("type_preuve", "proof_type"),
        "message_m": ("message_m", "message_m"),
        "verdict": ("verdict", "verdict"),
        "confidence": ("confiance_0_10", "confidence_0_10"),
        "time_s": ("temps_s", "time_s"),
        "session": ("session", "session"),
        "date": ("date", "date"),
        "notes": ("remarques", "notes"),
    },
    "p4_verdict_space": {
        "institution_id": ("id_institution", "institution_id"),
        "context_id": ("id_contexte", "context_id"),
        "verdict_code": ("code_verdict", "verdict_code"),
        "verdict_label": ("libelle_verdict", "verdict_label"),
        "legal_basis": ("fondement_juridique", "legal_basis"),
        "retained": ("retenu_oui_non", "retained_yes_no"),
        "notes": ("remarques", "notes"),
    },
    "p5_sessions": {
        "participant_id": ("id_participant", "participant_id"),
        "stratum": ("strate", "stratum"),
        "scheme": ("schema", "scheme"),
        "stimulus_id": ("id_stimulus", "stimulus_id"),
        "context_id": ("id_contexte", "context_id"),
        "proof_id": ("id_preuve", "proof_id"),
        "sigma_code": ("code_sigma", "sigma_code"),
        "message_m": ("message_m", "message_m"),
        "aid": ("aide", "aid"),
        "noise_condition": ("condition_bruit", "noise_condition"),
        "p_noise": ("p_bruit", "p_noise"),
        "verdict": ("verdict", "verdict"),
        "gold_verdict": ("verdict_reference", "gold_verdict"),
        "interpretation_error": ("erreur_interpretation", "interpretation_error"),
        "confidence": ("confiance_0_10", "confidence_0_10"),
        "time_s": ("temps_s", "time_s"),
        "session": ("session", "session"),
        "notes": ("remarques", "notes"),
    },
    "p6_simulation": {
        "run_id": ("id_execution", "run_id"),
        "seed": ("graine", "seed"),
        "channel": ("canal", "channel"),
        "noise_param": ("parametre_bruit", "noise_param"),
        "proof_type": ("type_preuve", "proof_type"),
        "encoding": ("encodage", "encoding"),
        "n_qubits": ("n_qubits", "n_qubits"),
        "h_c": ("H_C_bits", "H_C_bits"),
        "i_before": ("I_avant_bits", "I_before_bits"),
        "i_after": ("I_apres_bits", "I_after_bits"),
        "delta_i": ("delta_I_bits", "delta_I_bits"),
        "eta_hat": ("eta_chapeau", "eta_hat"),
        "fidelity_avg": ("fidelite_moyenne", "average_fidelity"),
        "trace_distance": ("distance_trace", "trace_distance"),
        "notes": ("remarques", "notes"),
    },
}

P1_DIMENSION_ITEMS = ("q02", "q03", "q04", "q05", "q06", "q07", "q08", "q10", "q11", "q12", "q13", "q14", "q15", "q16", "q17", "q19", "q20", "q21", "q22", "q23", "q24", "q25")

NUMERIC = {"phase", "presentation_rank", "verdict_v", *P1_DIMENSION_ITEMS, "q09_attention",
           "q18_attention", "q27_proof_contribution", "q28_attention", "q29_expertise",
           "attention_failures", "excluded", "n_categories", "entropy_bits",
           "presentation_rank", "dissimilarity", "round", "h_estimate", "lower_bound", "upper_bound",
           "confidence", "time_s", "p_noise", "interpretation_error", "noise_param", "n_qubits",
           "h_c", "i_before", "i_after", "delta_i", "eta_hat", "fidelity_avg", "trace_distance"}


def header(schema: str, lang: str) -> list[str]:
    """Header row of a template in ``lang`` ('fr' or 'en')."""
    i = {"fr": 0, "en": 1}[lang]
    return [names[i] for names in SCHEMAS[schema].values()]


def _to_float(s: str) -> float:
    s = (s or "").strip().replace(" ", "").replace(" ", "")
    if s == "":
        return float("nan")
    return float(s.replace(",", "."))


def detect_language(schema: str, columns: list[str]) -> str:
    cols = set(c.strip() for c in columns)
    fr = set(header(schema, "fr"))
    en = set(header(schema, "en"))
    if cols >= fr:
        return "fr"
    if cols >= en:
        return "en"
    missing_fr = sorted(fr - cols)
    missing_en = sorted(en - cols)
    raise ValueError(f"header does not match schema {schema!r}; missing (fr) {missing_fr} "
                     f"or (en) {missing_en}")


def read_template_text(text: str, schema: str) -> dict[str, np.ndarray]:
    first = text.splitlines()[0] if text else ""
    delim = ";" if first.count(";") > first.count(",") else ","
    reader = csv.DictReader(_io.StringIO(text), delimiter=delim)
    cols = [c.strip() for c in (reader.fieldnames or [])]
    lang = detect_language(schema, cols)
    i = {"fr": 0, "en": 1}[lang]
    mapping = {names[i]: canon for canon, names in SCHEMAS[schema].items()}
    data: dict[str, list] = {canon: [] for canon in SCHEMAS[schema]}
    for row in reader:
        row = {(k or "").strip(): (v or "").strip() for k, v in row.items()}
        if all(v == "" for v in row.values()):
            continue
        for src, canon in mapping.items():
            val = row.get(src, "")
            data[canon].append(_to_float(val) if canon in NUMERIC else val)
    out = {k: np.asarray(v, dtype=float if k in NUMERIC else object) for k, v in data.items()}
    out["_language"] = np.asarray([lang], dtype=object)
    return out


def read_template(path: str | Path, schema: str) -> dict[str, np.ndarray]:
    """Read a filled template (French or English header) into canonical columns."""
    text = Path(path).read_text(encoding="utf-8-sig")
    return read_template_text(text, schema)


def write_rows(path: str | Path, schema: str, lang: str, rows: list[Mapping]) -> None:
    """Write rows given with canonical keys into a template-shaped CSV."""
    canon = list(SCHEMAS[schema].keys())
    with open(path, "w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh)
        w.writerow(header(schema, lang))
        for r in rows:
            w.writerow([r.get(c, "") for c in canon])


def drop_missing(data: Mapping[str, np.ndarray], *columns: str) -> dict[str, np.ndarray]:
    """Remove rows where any of ``columns`` is empty / NaN."""
    n = len(next(v for k, v in data.items() if not k.startswith("_")))
    keep = np.ones(n, dtype=bool)
    for c in columns:
        col = data[c]
        if col.dtype == float:
            keep &= np.isfinite(col)
        else:
            keep &= np.asarray([str(x) != "" for x in col])
    return {k: (v[keep] if not k.startswith("_") else v) for k, v in data.items()}
