#let TITLE = [Dissecting the mechanisms of low-intensity focused ultrasound neuromodulation]

#let AUTHORS = [Paolo Marzolo · Daniel Ariselli · Mohammadreza Safari · Alberto Antonietti]

#let AFFIL = [NEARLab, Neuroengineering and Medical Robotics Laboratory, Politecnico di Milano]

#let VENUE = [Poster session · SISSA, Trieste · 22 September 2026]

#let FUNDER = [
  This project has been funded by the Italian Ministry of University and
  Research (MUR), Fondo Italiano per la Scienza 3, project SEVERUS: "In Silico
  modEling and in Vitro validation: Evaluating Responses in neuronal networks to
  focused UltraSound".

  BANDO FIS 3-2024-01620. CUP: D53C25002390001.
]

#let PEOPLE = (
  (img: "img/head-paolo.png", first: [Paolo], last: [Marzolo]),
  (img: "img/head-daniel.png", first: [Daniel], last: [Ariselli]),
  (img: "img/head-mohammadreza.png", first: [Mohammadreza], last: [Safari]),
  (img: "img/head-alberto.png", first: [Alberto], last: [Antonietti]),
)

#let QR-LABEL = [near-nes.github.io/severus-inctn]

#let LEDE = [
  Low-intensity focused ultrasound offers a non-invasive route to modulate neural activity with high spatial selectivity, but its cellular mechanisms remain unresolved and parameter-dependent. The *SEVERUS* project addresses this gap by testing alternative, non-exclusive hypotheses for focused ultrasound stimulation in neuronal networks.
]

#let make(h, fig-path: 150mm) = (
  // ── left column — in silico ────────────────────────────────────────────────
  left: [
    #(h.sub)[Proposed neuromodulation mechanisms]

    #(h.hyp-grid)((
      (
        n: "i",
        title: "Thermal transients",
        panel: "img/mech-thermal.png",
        body: [Heating shifts conductance and channel kinetics, short of damage.],
        predicts: [time-averaged intensity, not peak pressure.],
      ),
      (
        n: "ii",
        title: "Intramembrane cavitation",
        panel: "img/mech-cavitation.png",
        body: [Nanobubbles in the bilayer change capacitance; displacement
          currents follow.],
        predicts: [a frequency-dependent pressure threshold, indifferent to
          degassing.],
      ),
      (
        n: "iii",
        title: "Mechanosensitive gating",
        panel: "img/mech-mechano.png",
        body: [Force and deformation open Piezo- and TRP-like channels.],
        predicts: [sensitivity to channel blockers; cell-type specificity.],
      ),
      (
        n: "iv",
        title: "Membrane biophysics",
        panel: "img/mech-membrane.png",
        body: [Thickness, curvature and lipid state move capacitance. The panel
          shows flexoelectricity.],
        predicts: [an effect that survives blockade of (iii).],
      ),
      (
        n: "v",
        title: "Streaming, shear and radiation force",
        body: [Force on the cells and on the matrix they are coupled to;
          streaming adds shear.],
        predicts: [a slower time course. Gel embedding separates the two.],
      ),
      (
        n: "vi",
        title: "Glial relay",
        body: [Ultrasound acts on astrocytes through TRPA1; gliotransmitter
          release onto NMDARs does the rest. #(h.cite)[(Oh 2019)]],
        predicts: [nothing in neuron-only culture.],
      ),
    ))

    #(h.callout)[
      Sweep frequency, intensity, duty cycle and pulse duration, _in silico_ and verify experimentally _in vitro_.
    ]

    #(h.sub)[Modelling stack]

    #(h.stack-fig)(
      (
        (
          tool: "CAD",
          logo: none,
          does: [Chip geometry: channels, gel compartment, acoustic windows.],
          hands: [meshed stack],
        ),
        (
          tool: "COMSOL",
          logo: "img/logo-comsol.png",
          does: [Acoustic and thermal field in that geometry, not in free water.],
          hands: [pressure and temperature at the construct],
        ),
        (
          tool: "NESTML",
          logo: "img/logo-nestml.png",
          does: [Ion-channel kinetics and the neuron models they define.],
          hands: [generated model code],
        ),
        (
          tool: "NEST",
          logo: "img/logo-nest.png",
          does: [Spiking and network synchrony across the construct.],
          hands: none,
        ),
      ),
      coupler: (
        logo: "img/logo-python.png",
        does: [Coordinates and couples stages: field into membrane mechanics and capacitance, and that into the transmembrane current the channel models take.],
      ),
    )

  ],

  // ── right column — in vitro ────────────────────────────────────────────────
  right: [

    #(h.sub)[A history of confounds]

    #(h.confound)(
      [*Standing waves.* Rigid bottoms reflect, high sensitivity.
        #(h.cite)[(Hensel 2011; Secomski 2017; Tretbar 2025)]],
      [Absorber on the return path, 40° tilt.],
    )
    #(h.confound)(
      [*Exposure uncertainty.* Up to \~700% across standard well plates.
        #(h.cite)[(Leskinen & Hynynen 2012)]],
      [Field reported at the cell plane: tank scan plus accurate model of real
        stack.],
    )
    #(h.confound)(
      [*Transducer heating.* Above roughly 5% duty cycle, dry-coupled.
        #(h.cite)[(Tretbar 2025)]],
      [Thermal readout in the rig; duty cycle set against a measured ceiling.],
    )
    #(h.confound)(
      [*Readout motion.* \~40% of widefield calcium variance during sonication.
        #(h.cite)[(Kitahara & Tateno 2026)]],
      [Cells held in gel.],
    )

    #v(1fr)

    #(h.sub)[3D organ-on-chip platform]

    A perfused, compartmentalised microfluidic platform hosting a 3D neural construct under characterised sub-MHz exposure.

    #(h.figimg)("img/dissociation.png")[
      *The culture route*, inherited from earlier work in MimicLab at PoliMI.
    ]

    #v(1fr)

    *Human cells, in three dimensions.* Neurons and astrocytes in a gel
    construct, not a monolayer on glass. To verify (v) and (vi) we need the glia.

    *Concurrent stimulation and readout.* Ultrasound, electrophysiology and
    calcium imaging on the same construct, during exposure rather than after.

    *Sub-MHz, transcranial-compatible.* Staying below 1 MHz is what allows a
    result on this chip to be read against the in-vivo LIFU literature.

    #v(1fr)

    #(h.figimg)(
      "img/inverted_rig.svg",
      height: 160mm,
      title: [The inverted rig, 500 kHz, 40° tilt],
    )[
      Our current iteration of the rig design. It's a balancing act between optical path, acoustic transmission, thermal budgeting and practicality.
    ]
  ],

  // ── references ─────────────────────────────────────────────────────────────
  refs: (
    [Dell'Italia J, Sanguinetti JL, Monti MM, Bystritsky A, Reggente N (2022)
      #emph[Front Hum Neurosci] 16:872639. Mechanism panels (i)–(iv) adapted
      from it, CC BY 4.0.],
    [Hensel K, Mienkina MP, Schmitz G (2011) #emph[Ultrasound Med Biol]
      37(12):2105–2115.],
    [Kitahara R, Tateno T (2026) #emph[Proc BIOSTEC (BIODEVICES)] 101–108.],
    [Leskinen JJ, Hynynen K (2012) #emph[Ultrasound Med Biol] 38(5):777–794.],
    [Oh SJ et al. (2019) #emph[Curr Biol] 29(20):3386–3401.e8; correction
      #emph[Curr Biol] 30(5):948.],
    [Saccher M et al. (2022) #emph[Bioelectron Med] 8(1):2.],
    [Secomski W et al. (2017) #emph[Ultrasonics] 77:203–213.],
    [Tretbar SH et al. (2025) #emph[Appl Sci] 15(2):847.],
  ),

  // ── closing strip ──────────────────────────────────────────────────────────
  next: [
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 12mm,
      [*Measure the field we deliver.* Hydrophone scan plus a
        finite-element model of the real chip stack, with a thermal readout in
        the rig. ],
      [*Settle on an experimental design.* Which hypotheses to separate first,
        at which parameters, with which readouts. The model proposes the regimes
        where the six disagree and the platform will run them.],
      [*Close the loop.* First round at the bench under concurrent
        electrophysiology and calcium imaging, then the measurements go back
        into the model.],
    )
  ],
)
