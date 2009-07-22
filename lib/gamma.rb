class Gamma
  conds = <<"EOF"
control_30m
gamma_30m_2500g
control_40m
gamma_40m_2500g
control_60m
gamma_60m_2500g
gamma3__0000gy-0000m
gamma3__0000gy-0010m
gamma3__0000gy-0020m
gamma3__0000gy-0030m
gamma3__0000gy-0040m
gamma3__0000gy-0050m
gamma3__0000gy-0060m
gamma3__0000gy-0120m
gamma3__0000gy-0240m
gamma3__2500gy-0000m
gamma3__2500gy-0010m
gamma3__2500gy-0020m
gamma3__2500gy-0030m
gamma3__2500gy-0040m
gamma3__2500gy-0050m
gamma3__2500gy-0060m
gamma3__2500gy-0120m
gamma3__2500gy-0240m
gamma2__0000gy-0000m
gamma2__0000gy-0010m
gamma2__0000gy-0020m
gamma2__0000gy-0030m
gamma2__0000gy-0040m
gamma2__0000gy-0050m
gamma2__0000gy-0060m
gamma2__0000gy-0120m
gamma2__0000gy-0240m
gamma2__2500gy-0000m
gamma2__2500gy-0010m
gamma2__2500gy-0020m
gamma2__2500gy-0030m
gamma2__2500gy-0040m
gamma2__2500gy-0050m
gamma2__2500gy-0060m
gamma2__2500gy-0120m
gamma2__2500gy-0240m
EOF
# exps = Experiment.find_by_sql(["select * from experiments where id in (select distinct experiment_id from conditions where name in (?))",conds.split("\n")])
 exps = Experiment.find_by_sql("select * from experiments where name like '\%gamma\%'")
 kenia = Paper.find_by_short_name("Whitehead, 2006")
 for exp in exps
   puts exp.name
   exp.papers << kenia
 end
end