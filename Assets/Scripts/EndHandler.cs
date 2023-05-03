using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndHandler : MonoBehaviour
{
    public static EndHandler s;
    public GameObject endJellyFish;
    public GameObject[] endPlants;
    public Transform player;

    [Header("End fade black values")]
    public Image blackEndScreen;
    public float duration;
    private float startTime = 0;

    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }

    void Start()
    {
        //End();
    }

    public void End()
    {
        OutsideSM.s.PlayEndSound();
        StartCoroutine(StartEnd());
    }

    public IEnumerator StartEnd()
    {
        yield return new WaitForSeconds(2f);
        //StartCoroutine(growLayerGrass());

        for (int i = 0; i < endPlants.Length; i++)
        {
            endPlants[i].SetActive(true);
            yield return new WaitForSeconds(2f);
        }

        Credit.s.Show();
        endJellyFish.transform.position = player.position;
        endJellyFish.SetActive(true);

        yield return new WaitForSeconds(15f);
        StartCoroutine(FadeBlack());
         
    }

    private IEnumerator FadeBlack()
    {
        while (startTime < duration)
        {
            startTime += Time.deltaTime;
            blackEndScreen.color = new Color(0, 0, 0, Mathf.Lerp(0, 1, startTime / duration));
            yield return null;
        }

        EndApp();
    }

    private void EndApp()
    {
        EktoVRManager.S.ekto.StopSystem();
        Application.Quit();
    }

/*    private IEnumerator growLayerGrass()
    {
        for(int i = 0; i< endPlants.Length; i++)
        {
            endPlants[i].SetActive(true);
            yield return new WaitForSeconds(3f);
        }
    }*/
}
