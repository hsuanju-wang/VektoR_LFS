using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndHandler : MonoBehaviour
{
    public static EndHandler s;
    public GameObject endJellyFish;
    public GameObject endPlants;
    public Transform player;

    public GameObject target;
    public GameObject cloneFrom;
    public int amount;
    public float radius;

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

    public void End()
    {
        OutsideSM.s.PlayEndSound();
        Credit.s.Show();
        endJellyFish.transform.position = player.position;
        endJellyFish.SetActive(true);
        endPlants.SetActive(true);
    }

    void Start()
    {
        Surround(target, cloneFrom, amount, radius);
    }

    // this function replicate the object surrounding the target
    public void Surround(GameObject target, GameObject prefab, int amount, float radius)
    {
        float angle = 360f / amount;

        for (int i = 0; i < amount; i++)
        {
            GameObject go = Instantiate(prefab) as GameObject;

            go.transform.Rotate(Vector3.up, angle * i);
            go.transform.position = target.transform.position - (go.transform.forward * radius);
            // OR  go.GetComponent<NavMeshAgent>().Warp(target.transform.position-(go.transform.forward*radius));
        }
    }
}
