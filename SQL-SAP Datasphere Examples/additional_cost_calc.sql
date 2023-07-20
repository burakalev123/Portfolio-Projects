case
    when BonusGroup = 'Yes'
    and bonus_group = 'BonusGroup' then case
        when Percent is null then case
            when account = '641100_0'
            and lc_total_target_cash > spec_salary then Absolut
            when account != '641100_0' then Absolut
        end
        when Absolut is null then case
            when account = '641100' then case
                when spec_salary < lc_total_target_cash then spec_salary * Percent
                else lc_total_target_cash * Percent
            end
            when account = '641100_0' then case
                when spec_salary < lc_total_target_cash then (lc_total_target_cash - spec_salary) * Percent
            end
            else lc_total_target_cash * Percent
        end
    end
    when BonusGroup != 'Yes'
    and bonus_group = 'NonBonusGroup' then case
        when Percent is null then case
            when account = '641100_0'
            and lc_total_target_cash > spec_salary then Absolut
            when account != '641100_0' then Absolut
        end
        when Absolut is null then case
            when account = '641100' then case
                when spec_salary < lc_total_target_cash then spec_salary * Percent
                else lc_total_target_cash * Percent
            end
            when account = '641100_0' then case
                when spec_salary < lc_total_target_cash then (lc_total_target_cash - spec_salary) * Percent
            end
            else lc_total_target_cash * Percent
        end
    end
end