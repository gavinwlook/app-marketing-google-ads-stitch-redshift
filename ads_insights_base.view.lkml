include: "ad_transformations_base.view"

view: ads_insights_base_fb_adapter {
  extension: required
  extends: [ad_transformations_base_fb_adapter]

  dimension: account_id {
    hidden: yes
    type: string
  }

  dimension: account_name {
    type: string
  }

  dimension: ad_id {
    hidden: yes
    type: string
  }

  dimension: ad_name {
    type: string
  }

  dimension: adset_id {
    hidden: yes
    type: string
  }

  dimension: adset_name {
    type: string
  }

  dimension: campaign_id {
    hidden: yes
    type: string
  }

  dimension: campaign_name {
    type: string
  }

  dimension: clicks {
    hidden: yes
    type: number
  }

  dimension: frequency {
    hidden: yes
    type: number
  }

  dimension: impressions {
    hidden: yes
    type: number
  }

  dimension: objective {
    type: string
  }

  dimension: reach {
    hidden: yes
    type: number
  }

  dimension: spend {
    hidden: yes
    type: number
  }

  dimension: total_action_value {
    hidden: yes
    type: number
  }

  dimension: total_actions {
    hidden: yes
    type: number
  }
}
