using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Step : MonoBehaviour
{
    public float footPrintCloseTime;
    public GameObject[] steps;
    public int currentStepIndex;
    private int prevStepIndex;

    // Start is called before the first frame update
    void Start()
    {
        currentStepIndex = 0;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void NextStep()
    {
        prevStepIndex = currentStepIndex;
        StartCoroutine(CloseFootPrint());

        if (currentStepIndex != steps.Length - 1)
        {
            currentStepIndex++;
            steps[currentStepIndex].SetActive(true);
        }
    }

    private IEnumerator CloseFootPrint()
    {
        yield return new WaitForSeconds(footPrintCloseTime);
        steps[prevStepIndex].SetActive(false);
    }

}
