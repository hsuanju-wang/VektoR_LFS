using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BootReactivate : MonoBehaviour
{
    public bool isStartGuide;

    [Header("UIs")]
    public BootReactivatePanel reactivatePanel;
    public TextMeshProUGUI dialogueUITxt;

    private bool isStartCheckInCircle;
    // Start is called before the first frame update
    void Start()
    {
        isStartGuide = false;
        isStartCheckInCircle = false;
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void StartBootReactivate()
    {
        reactivatePanel.Show();

        if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            //Activate suit Dialogue
            
        }
        else
        {
            //Step in circle Dialgoue before Activate suit Dialogue
            reactivatePanel.ShowText("");
        }
        reactivatePanel.Show();
    }

    public IEnumerator ShowReactivateGuide()
    {
        reactivatePanel.Show();
        yield return new WaitForSeconds(3f);

    }


}
